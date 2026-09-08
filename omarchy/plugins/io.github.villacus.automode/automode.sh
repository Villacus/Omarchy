#!/bin/bash
# Enter / exit Automatic Game Mode: snapshot desktop state, apply gaming
# optimizations, restore on exit.

set -u

SELF="$(readlink -f "$0")"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/automode"
ACTIVE_FLAG="$STATE_DIR/active"
RESTORE="$STATE_DIR/restore.json"

mkdir -p "$STATE_DIR"

have() { command -v "$1" >/dev/null 2>&1; }

notify() {
  if have notify-send; then
    notify-send -i applications-games "Automatic Game Mode" "$1" || true
  fi
}

dnd_on() {
  local state
  state="$(omarchy-shell notifications isDnd 2>/dev/null || echo off)"
  [[ "${state,,}" == "on" ]]
}

nightlight_on() {
  local json enabled
  json="$(omarchy-toggle-nightlight --status 2>/dev/null || echo '{}')"
  enabled="$(jq -r '.enabled // false' <<<"$json" 2>/dev/null || echo false)"
  [[ "$enabled" == "true" ]]
}

stay_awake_on() {
  [[ -f "$HOME/.local/state/omarchy/indicators/stay-awake" ]]
}

hypr_available() {
  have hyprctl && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" || -n "$(hyprctl instances 2>/dev/null | head -n1)" ]]
}

hypr_value() {
  local opt="$1" raw
  raw="$(hyprctl getoption "$opt" -j 2>/dev/null || echo "")"
  [[ -n "$raw" ]] || { echo ""; return; }
  jq -r '
    if has("bool") then (if .bool then "1" else "0" end)
    elif .int != null then (.int | tostring)
    elif .float != null then (.float | tostring)
    elif (.css // "") != "" then .css
    elif (.custom // "") != "" and .custom != "null" then .custom
    elif (.str // "") != "" then .str
    else empty
    end
  ' <<<"$raw" 2>/dev/null || true
}

hypr_eval() {
  local out
  out="$(hyprctl eval "$1" 2>&1)" || return 1
  case "$out" in
    error:*|*": error "*) return 1 ;;
  esac
  return 0
}

hypr_lua_gap() {
  local val="$1"
  local -a g=()
  read -ra g <<<"$val"
  local part
  for part in "${g[@]}"; do
    [[ "$part" =~ ^-?[0-9]+([.][0-9]+)?$ ]] || { echo ""; return; }
  done
  case ${#g[@]} in
    1) printf '%s\n' "${g[0]}" ;;
    2) printf '{ top = %s, right = %s, bottom = %s, left = %s }\n' "${g[0]}" "${g[1]}" "${g[0]}" "${g[1]}" ;;
    3) printf '{ top = %s, right = %s, bottom = %s, left = %s }\n' "${g[0]}" "${g[1]}" "${g[2]}" "${g[1]}" ;;
    4) printf '{ top = %s, right = %s, bottom = %s, left = %s }\n' "${g[0]}" "${g[1]}" "${g[2]}" "${g[3]}" ;;
    *) echo "" ;;
  esac
}

hypr_lua_literal() {
  local opt="$1" val="$2"
  case "$opt" in
    *:enabled)
      case "$val" in
        1|true|TRUE) echo true ;;
        0|false|FALSE) echo false ;;
        *) echo "" ;;
      esac
      ;;
    *gaps_in|*gaps_out) hypr_lua_gap "$val" ;;
    *)
      if [[ "$val" =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
        printf '%s\n' "$val"
      else
        echo ""
      fi
      ;;
  esac
}

hypr_lua_config() {
  local opt="$1" lit="$2" acc
  acc="$lit"
  local rest="$opt"
  local -a keys=()
  while [[ "$rest" == *:* ]]; do
    keys+=("${rest%%:*}")
    rest="${rest#*:}"
  done
  keys+=("$rest")
  local i
  for (( i=${#keys[@]}-1; i>=0; i-- )); do
    acc="{ ${keys[i]} = ${acc} }"
  done
  printf '%s\n' "$acc"
}

hypr_set() {
  local opt="$1" val="$2" lit cfg
  [[ -n "$val" ]] || return 0
  lit="$(hypr_lua_literal "$opt" "$val")"
  if [[ -n "$lit" ]]; then
    cfg="$(hypr_lua_config "$opt" "$lit")"
    hypr_eval "hl.config(${cfg})" && return 0
  fi
  hyprctl keyword "$opt" "$val" >/dev/null 2>&1 || true
}

set_power_profile() {
  have powerprofilesctl && powerprofilesctl set performance >/dev/null 2>&1 || true
}

restore_power_profile() {
  local profile="$1"
  [[ -n "$profile" ]] && have powerprofilesctl && powerprofilesctl set "$profile" >/dev/null 2>&1 || true
}

set_dnd() { omarchy-shell notifications setDnd "$1" >/dev/null 2>&1 || true; }
set_nightlight() { omarchy-toggle-nightlight >/dev/null 2>&1 || true; }
set_stay_awake() {
  if [[ "$1" == "true" ]]; then
    omarchy-toggle-idle stay-awake >/dev/null 2>&1 || true
  else
    omarchy-toggle-idle allow-idle >/dev/null 2>&1 || true
  fi
}

snapshot() {
  local hypr_json="{}"
  if hypr_available; then
    hypr_json="$(jq -cn \
      --arg animations "$(hypr_value animations:enabled)" \
      --arg blur "$(hypr_value decoration:blur:enabled)" \
      --arg shadow "$(hypr_value decoration:shadow:enabled)" \
      --arg gaps_in "$(hypr_value general:gaps_in)" \
      --arg gaps_out "$(hypr_value general:gaps_out)" \
      --arg border "$(hypr_value general:border_size)" \
      --arg rounding "$(hypr_value decoration:rounding)" \
      '{
        animations: $animations,
        blur: $blur,
        shadow: $shadow,
        gaps_in: $gaps_in,
        gaps_out: $gaps_out,
        border: $border,
        rounding: $rounding
      }')"
  fi

  jq -cn \
    --argjson dnd "$(dnd_on && echo true || echo false)" \
    --argjson nightlight "$(nightlight_on && echo true || echo false)" \
    --argjson stayAwake "$(stay_awake_on && echo true || echo false)" \
    --arg power "$(powerprofilesctl get 2>/dev/null || echo '')" \
    --argjson hypr "$hypr_json" \
    '{
      dnd: $dnd,
      nightlight: $nightlight,
      stayAwake: $stayAwake,
      power: $power,
      hypr: $hypr
    }' >"$RESTORE"
}

apply_gaming() {
  set_dnd on
  nightlight_on && set_nightlight
  set_stay_awake true
  set_power_profile

  if hypr_available; then
    hypr_eval 'hl.config({
      animations = { enabled = false },
      decoration = {
        blur = { enabled = false },
        shadow = { enabled = false },
        rounding = 0
      },
      general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 1
      }
    })' || {
      hypr_set animations:enabled 0
      hypr_set decoration:blur:enabled 0
      hypr_set decoration:shadow:enabled 0
      hypr_set general:gaps_in 0
      hypr_set general:gaps_out 0
      hypr_set general:border_size 1
      hypr_set decoration:rounding 0
    }
  fi
}

restore_desktop() {
  [[ -f "$RESTORE" ]] || return 0
  local json animations
  json="$(cat "$RESTORE")"

  if [[ "$(jq -r '.dnd // false' <<<"$json")" == "false" ]]; then
    set_dnd off
  fi
  if [[ "$(jq -r '.nightlight // false' <<<"$json")" == "true" ]]; then
    set_nightlight
  fi
  set_stay_awake "$(jq -r '.stayAwake // false' <<<"$json")"
  restore_power_profile "$(jq -r '.power // empty' <<<"$json")"

  if hypr_available; then
    animations="$(jq -r '.hypr.animations // empty' <<<"$json")"
    if [[ -z "$animations" && -z "$(jq -r '.hypr.gaps_in // empty' <<<"$json")" ]]; then
      hyprctl reload >/dev/null 2>&1 || true
    else
      hypr_set animations:enabled "$animations"
      hypr_set decoration:blur:enabled "$(jq -r '.hypr.blur // empty' <<<"$json")"
      hypr_set decoration:shadow:enabled "$(jq -r '.hypr.shadow // empty' <<<"$json")"
      hypr_set general:gaps_in "$(jq -r '.hypr.gaps_in // empty' <<<"$json")"
      hypr_set general:gaps_out "$(jq -r '.hypr.gaps_out // empty' <<<"$json")"
      hypr_set general:border_size "$(jq -r '.hypr.border // empty' <<<"$json")"
      hypr_set decoration:rounding "$(jq -r '.hypr.rounding // empty' <<<"$json")"
    fi
  fi

  rm -f "$RESTORE"
}

cmd_enter() {
  [[ -f "$ACTIVE_FLAG" ]] && return 0
  snapshot
  apply_gaming
  touch "$ACTIVE_FLAG"
  notify "ON — Steam game detected, desktop optimized"
}

cmd_exit() {
  [[ -f "$ACTIVE_FLAG" ]] || return 0
  restore_desktop
  rm -f "$ACTIVE_FLAG"
  notify "OFF — Steam game ended, desktop restored"
}

case "${1:-}" in
  enter) cmd_enter ;;
  exit) cmd_exit ;;
  *)
    echo "Usage: automode.sh enter | exit" >&2
    exit 1
    ;;
esac

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Linux desktop dotfiles for **Omarchy** (Hyprland-based desktop environment) on **CachyOS** (Arch Linux). Configs are organized by application and deployed via symlinks (matching GNU Stow structure).

**Owner:** Villacus

## Repository Structure

```
bash/              → .bashrc with Omarchy defaults, custom aliases, PATH, fastfetch
git/               → .gitconfig with user info, aliases, LFS filters
hypr/.config/hypr/ → Hyprland config in Lua (monitors, bindings, input, looknfeel, autostart, hyprlock, hypridle, hyprsunset)
omarchy/.config/    → Quickshell status bar layout (`shell.json`)
scripts/.config/   → Custom shell scripts for wallpapers, music control (MPRIS), wallpaper-engine
omarchy-extensions/→ Omarchy menu extension for multi-monitor wallpaper selector
opencode/          → OpenCode AI configuration (AGENTS.md with system documentation)
ssh/.ssh/          → SSH config (keys gitignored)
```

All directories follow the structure `<app>/.config/<app>/` or `<app>/.<config-file>` to mirror `$HOME` when symlinked.

## Hardware Configuration

**Dual monitor setup** — monitor config lives in `hypr/.config/hypr/monitors.lua`:
- **DP-3** (Philips 200V4): 1600x900@60, left monitor at position 0x180
- **DP-2** (ASUS VG249Q3R): 1920x1080@180, right monitor at position 1600x100, primary

Workspace assignments: workspaces 1,3,5 → DP-2; workspaces 2,4 → DP-3.

## Hyprland Configuration Architecture

Main entry point: `hypr/.config/hypr/hyprland.lua`

**Module loading pattern:**
1. Loads Omarchy defaults from `$OMARCHY_PATH` (typically `~/.local/share/omarchy`)
2. Overrides with user modules from `hypr/.config/hypr/`:
   - `monitors.lua` — display config, scaling, workspace rules
   - `input.lua` — keyboard, mouse, touchpad settings
   - `bindings.lua` — application launches, window management, custom scripts
   - `looknfeel.lua` — animations, borders, shadows, window rules
   - `autostart.lua` — apps and scripts to launch at login

**Key bindings** (see `bindings.lua`):
- Applications: `Super+Return` (terminal), `Super+Shift+B` (browser), `Super+Shift+V` (VSCode)
- Custom: `Super+Alt+A` (audio output switcher), `Super+Shift+S` (screenshot)
- Media controls via MPRIS through `scripts/.config/scripts/` helpers

**Related configs:**
- `hyprlock.conf` — lockscreen styling
- `hypridle.conf` — idle timeout actions (lock, suspend)
- `hyprsunset.conf` — blue light filter
- `xdph.conf` — XDG desktop portal settings

## Wallpaper System

**Architecture:** Multi-monitor wallpaper manager supporting static images through the Omarchy shell and animated wallpapers (Wallpaper Engine via `linux-wallpaperengine`). State persists across reboots and theme changes.

**Key scripts** (in `scripts/.config/scripts/`):
- `restore-wallpapers` — Boot script (called from `autostart.lua`), reads `~/.local/state/omarchy/current/wallpapers.conf` and restores per-monitor wallpapers
- `omarchy-wallpaper-engine` — Main script: launches `linux-wallpaperengine` for a specific monitor, manages PIDs, updates state
- `set-wallpaper-engine` — Wrapper that logs to `we-debug.log` and delegates to `omarchy-wallpaper-engine`
- `omarchy-background-selector` — Interactive TUI: select wallpaper → select monitor
- `setup-wallpaper-engine-previews.sh` — Generates thumbnails from Steam Workshop wallpapers

**State files** (in `~/.local/state/omarchy/current/`):
- `wallpapers.conf` — Per-monitor assignments: `<monitor>:<type>:<value>` (e.g., `DP-2:static:/path/to/image.jpg` or `DP-3:wallpaper-engine:1613667090`)
- `wallpaper-engine-pids/<MONITOR>.pid` — PIDs for running wallpaper engine instances per monitor
- `background` — Symlink to current wallpaper for lockscreen

**Wallpaper Engine paths:**
- Workshop content: `/mnt/Games/SteamLibrary/steamapps/workshop/content/431960/<ID>/`
- Assets: `/mnt/Games/SteamLibrary/steamapps/common/wallpaper_engine/assets`
- Preview thumbnails: `~/.config/omarchy/backgrounds/wallpaper-engine/wallpaper_<ID>.png`

**Boot flow:**
1. `autostart.lua` → `restore-wallpapers`
2. Reads `wallpapers.conf` line by line
3. For `static:` → calls `omarchy-theme-bg-set <path>`, which updates the Omarchy shell background
4. For `wallpaper-engine:` → calls `set-wallpaper-engine <ID> <monitor>`

**Theme changes:** `omarchy theme set` only regenerates `current/theme/` and does not touch `wallpapers.conf`, so Wallpaper Engine state survives theme switches. Static wallpaper paths reference `current/theme/backgrounds/<file>`, so they break if the new theme lacks that file.

**Omarchy menu integration:** `omarchy-extensions/.config/omarchy/extensions/menu.sh` overrides the default background menu to call `omarchy-background-selector`.

## Music Control

MPRIS integration via custom scripts:
- `mpris-cliamp.sh` — CLIAMP/MPRIS status helper (historically used by Waybar)
- `playpause.sh`, `next.sh`, `prev.sh` — Playback controls
- `player-volume.sh` — Volume control

## Quickshell Configuration

The active Omarchy bar is Quickshell, configured in `omarchy/.config/omarchy/shell.json` and deployed to `~/.config/omarchy/shell.json`.

- `bar.layout.left`, `center`, and `right` define the widget placement.
- `bar.position` and `bar.transparent` control the bar presentation.
- `idle.lock` and `idle.screensaver` define shell idle actions.

Theme colors and dimensions are generated under `~/.local/state/omarchy/current/theme/` and are not tracked as personal dotfiles.

Restart the bar with:
```bash
omarchy restart shell
```

The historical Waybar configuration was removed after the Quattro migration; Waybar is not an active component.

Output and monitor assignments remain in `hypr/.config/hypr/monitors.lua`.

## Common Development Tasks

Since this is a dotfiles repository, "development" means editing configs and testing them live.

**Testing Hyprland changes:**
```bash
# Reload Hyprland config (for most changes)
hyprctl reload

# Check syntax errors
lua -c ~/.config/hypr/hyprland.lua

# List monitors and workspaces
hyprctl monitors
hyprctl workspaces
```

**Testing wallpaper scripts:**
```bash
# Set wallpaper manually
~/.config/scripts/set-wallpaper-engine <ID> <MONITOR>

# Check logs
tail -f ~/.local/state/omarchy/current/we-debug.log
tail -f ~/.local/state/omarchy/current/restore-wallpapers.log

# Regenerate wallpaper previews
~/.config/scripts/setup-wallpaper-engine-previews.sh
```

**Reload Quickshell:**
```bash
omarchy restart shell
```

**Deployment:**
Configs are deployed by symlinking directories into `$HOME`. This repo uses the same directory structure as the target location (e.g., `bash/.bashrc` → `~/.bashrc`, `hypr/.config/hypr/` → `~/.config/hypr/`).

To deploy changes: either manually symlink or use a tool like GNU Stow from the repo root.

## Important Notes

- **Omarchy integration:** This setup extends Omarchy (a Hyprland-based desktop environment). Many commands and scripts are Omarchy-specific (e.g., `omarchy-menu`, `omarchy-launch-or-focus-tui`, `omarchy theme set`). The default configs are sourced from `$OMARCHY_PATH` (typically `~/.local/share/omarchy`), then overridden by user configs in this repo.

- **Path assumptions:** Wallpaper Engine scripts hardcode `/mnt/Games/SteamLibrary/` for the Steam library location. Scripts assume `~/.config/scripts/` is symlinked from `scripts/.config/scripts/`.

- **Multi-monitor specificity:** Monitor names (DP-2, DP-3) are hardcoded in `monitors.lua` and wallpaper state files. Changing hardware requires updating these references.

- **Lua-based Hyprland config:** Hyprland is configured via Lua DSL (not the traditional `hyprland.conf`). Functions like `hl.monitor()`, `o.bind()`, `hl.workspace_rule()` are part of Omarchy's Lua API.

- **Custom API routing:** `.bashrc` sets `ANTHROPIC_BASE_URL=http://localhost:20128` to route Claude Code through a local gateway (OmniRoute) for free tier + fallback routing.
# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

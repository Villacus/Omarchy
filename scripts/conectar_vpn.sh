#!/usr/bin/env bash
# ~/.config/scripts/conectar_vpn.sh — VPN de la EHU + montaje de BILDU
# Uso: conectar_vpn.sh [up|down|toggle|status]   (sin argumentos = toggle)
set -u

# Directorio del script (aquí está el .env con SECRET_KEY=...)
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
ENV_FILE=$SCRIPT_DIR/.env

CONF=/etc/openfortivpn/ehu.conf
CRED=$HOME/.config/.smbcred
MNT=$HOME/BILDU
SHARE=//10.10.63.23/home
UNIT=ehu-vpn

is_up()      { systemctl is-active --quiet "$UNIT"; }
# Lee /proc/mounts: no toca el montaje, así que nunca se cuelga aunque esté "stale"
is_mounted() { grep -qs " $MNT " /proc/mounts; }
has_ip()     { ip -4 addr show dev ppp0 2>/dev/null | grep -q inet; }

unmount_bildu() {
    is_mounted || return 0
    # -l: lo desengancha ya, aunque esté ocupado o el servidor no responda
    # -f: cancela las peticiones pendientes
    sudo umount -f -l "$MNT" 2>/dev/null
}

up() {
    if is_up; then echo "VPN ya activa"; return 0; fi

    [[ -r $ENV_FILE ]] || { echo "Falta $ENV_FILE"; return 1; }
    local secret otp
    secret=$(sed -n 's/^SECRET_KEY=//p' "$ENV_FILE" | head -n1 | tr -d "\"' \r")
    [[ -n $secret ]] || { echo "SECRET_KEY vacío en $ENV_FILE"; return 1; }

    unmount_bildu              # limpia cualquier montaje colgado de una sesión anterior

    # El OTP se genera justo antes de conectar, para que no caduque mientras escribes la contraseña
    otp=$(oathtool --totp -b "$secret") || return 1

    # openfortivpn corre como servicio transitorio de systemd (sin terminal).
    # Cuando el servicio se para -- por "down" o porque la VPN se cae sola --
    # ExecStopPost desmonta BILDU. El "-" ignora el error si no estaba montado.
    sudo systemd-run --quiet --collect --unit="$UNIT" \
        -p "ExecStopPost=-/usr/bin/umount -f -l $MNT" \
        openfortivpn -c "$CONF" --otp="$otp" || return 1

    echo -n "Conectando"
    local i
    for i in $(seq 1 60); do
        if ! is_up; then
            echo; echo "openfortivpn ha fallado:"
            sudo journalctl -u "$UNIT" -n 15 --no-pager
            return 1
        fi
        has_ip && break
        echo -n "."; sleep 0.5
    done
    echo
    has_ip || { echo "Timeout esperando el túnel"; down; return 1; }

    # Split DNS para systemd-resolved (evita conflictos con Tailscale)
    sudo resolvectl dns ppp0 10.10.13.107 10.10.13.108
    sudo resolvectl domain ppp0 '~ehu.eus'

    mkdir -p "$MNT"
    # soft: si el servidor deja de responder, devuelve error en vez de colgar el proceso
    # echo_interval=10: detecta antes que el servidor ha desaparecido
    if ! sudo mount -t cifs "$SHARE" "$MNT" \
        -o "credentials=$CRED,uid=$(id -u),gid=$(id -g),iocharset=utf8,sec=ntlmssp,vers=2.1,soft,echo_interval=10"; then
        echo "Falló el montaje; cierro la VPN"
        down
        return 1
    fi
    echo "VPN activa y BILDU montado en $MNT"
}

down() {
    unmount_bildu                             # primero el montaje, con el túnel aún arriba
    sudo systemctl stop "$UNIT" 2>/dev/null   # SIGTERM a openfortivpn (+ ExecStopPost como red de seguridad)
    echo "VPN desactivada y BILDU desmontado"
}

status() {
    if is_up; then echo "VPN: activa"; else echo "VPN: inactiva"; fi
    if is_mounted; then echo "BILDU: montado"; else echo "BILDU: desmontado"; fi
}

case "${1:-toggle}" in
    up|on)    up ;;
    down|off) down ;;
    toggle)   if is_up; then down; else up; fi ;;
    status)   status ;;
    *)        echo "Uso: $0 {up|down|toggle|status}"; exit 1 ;;
esac

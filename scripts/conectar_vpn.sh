#!/usr/bin/expect -f

# Configuración
set timeout 30
set secret_key "M52RN2OVTAZA57PC"
set conf_file "/home/villacus/.config/ehu-vpn.conf"

# Generar el código OTP
set otp [exec oathtool --totp -b $secret_key]

# Ejecutar openfortivpn
spawn sudo openfortivpn -c $conf_file

# Interactuar con la terminal para el OTP
expect "Please enter one-time password:"
send "$otp\r"

# Esperar a que el túnel esté listo
expect "Tunnel is up and running."

# Configurar el Split DNS para systemd-resolved (evita conflictos con Tailscale)
exec sudo resolvectl dns ppp0 10.10.13.107 10.10.13.108
exec sudo resolvectl domain ppp0 ~ehu.eus

# Mantener la sesión interactiva abierta
interact

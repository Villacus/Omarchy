#!/usr/bin/expect -f

# Configuración
set timeout 30

# Asegurar que el montaje se desmonte al salir
trap {
    exec sudo umount /home/villacus/BILDU
    exit
} {SIGINT SIGTERM}

# Obtener la ruta absoluta del directorio donde está el script
set script_dir [file dirname [file normalize [info script]]]
set env_file [file join $script_dir ".env"]

# Leer variables de entorno (por si acaso, aunque no parece usarse mucho aquí)
if {[file exists $env_file]} {
    set fp [open $env_file r]
    while {[gets $fp line] >= 0} {
        if {[regexp {^SECRET_KEY=(.*)$} $line match value]} {
            set secret_key $value
        }
    }
    close $fp
}
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

# Montar unidad BILDU usando credenciales seguras y rutas absolutas
exec mkdir -p /home/villacus/BILDU

# Montamos usando el archivo de credenciales
exec sudo mount -t cifs //10.10.63.23/home /home/villacus/BILDU -o credentials=/home/villacus/.config/.smbcred,uid=1000,gid=1000,iocharset=utf8,sec=ntlmssp,vers=2.1

# Mantener la sesión interactiva abierta
interact

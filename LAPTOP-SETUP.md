# Checklist para Portátil

## ✅ Pre-instalación

- [ ] Instalar GNU Stow: `sudo pacman -S stow`
- [ ] Instalar Omarchy (si no está instalado)
- [ ] Clonar dotfiles: `git clone <tu-repo> ~/dotfiles`

## 📦 Instalación

```bash
cd ~/dotfiles
./install.sh
```

El script:
- ✓ Crea backups automáticos de configs existentes
- ✓ Usa symlinks (cambios en el repo = cambios en sistema)
- ✓ Valida los destinos de Stow al terminar
- ✓ Abre el editor para adaptar monitores y la configuración de Quickshell
- ✓ Pregunta confirmación antes de sobrescribir

## ⚙️ Configuración específica de portátil

### 1. Monitores y barra (CRÍTICO)
El instalador abre estas configuraciones después de desplegar y validar los symlinks:
- `hypr/.config/hypr/monitors.lua`
- `omarchy/.config/omarchy/shell.json`

Quickshell obtiene los nombres de monitores desde Hyprland; no hay una configuración de salida de Waybar que adaptar.

Antes o durante esa edición, consulta las salidas disponibles:
```bash
hyprctl monitors
```

### 2. Wallpaper Engine (OPCIONAL)
Si no tienes Steam/Wallpaper Engine, comenta estas líneas en:
- `hypr/.config/hypr/autostart.lua` → línea de `restore-wallpapers`
- O edita `scripts/.config/scripts/restore-wallpapers` para solo cargar fondos estáticos

### 3. Rutas hardcoded a revisar
- `/mnt/Games/SteamLibrary/` en scripts de wallpaper-engine
- Ajusta según tu instalación de Steam

### 4. Claves SSH
El instalador solo puede desplegar la clave pública incluida en el paquete. La clave privada se gestiona manualmente fuera del repositorio: no se copia, genera ni modifica durante la instalación.

## 🧪 Verificación post-instalación

```bash
# Verificar symlinks
ls -la ~ | grep dotfiles
ls -la ~/.config/ | grep dotfiles

# Probar Hyprland
hyprctl reload

# Verificar Quickshell
ps -eo pid,args | grep '[q]uickshell'
omarchy restart shell

# Verificar la configuración activa
readlink -f ~/.config/omarchy/shell.json
cat ~/.config/omarchy/shell.json >/dev/null
```

## 🔄 Flujo de trabajo diario

```bash
# Cambios en el repo se reflejan automáticamente (son symlinks)
cd ~/dotfiles
nvim hypr/.config/hypr/bindings.lua
# Guardar y recargar: Super+Shift+R o `hyprctl reload`

# Commit de cambios
git add .
git commit -m "..."
git push
```

## 🗑️ Desinstalación

```bash
cd ~/dotfiles
./uninstall.sh
```

## 📝 Configuraciones incluidas

- ✓ Hyprland (Lua config)
- ✓ Quickshell/Omarchy (barra y paneles)
- ✓ Alacritty (terminal)
- ✓ Bash (aliases, PATH)
- ✓ Git (config, aliases)
- ✓ Starship (prompt)
- ✓ Fastfetch (system info)
- ✓ Btop (system monitor)
- ✓ Mimeapps (default apps)
- ✓ Scripts personalizados
- ✓ Clave pública SSH
- ✓ OpenCode config

## ⚠️ Problemas comunes

### Hyprland no inicia
- Revisa `monitors.lua` — nombres de monitores incorrectos
- Verifica paths en `autostart.lua`

### Wallpapers no se restauran
- Wallpaper Engine no instalado → comentar `restore-wallpapers` en autostart
- Paths incorrectos en `/mnt/Games/` → editar scripts

### Quickshell no aparece
- Verifica que `~/.config/omarchy/shell.json` apunte al paquete `omarchy` del repositorio.
- Reinicia la barra con `omarchy restart shell`.
- Comprueba el proceso con `ps -eo pid,args | grep '[q]uickshell'`.

### Permisos de clave pública SSH
```bash
chmod 644 ~/.ssh/id_ed25519.pub
```

La clave privada se gestiona manualmente fuera de este repositorio.

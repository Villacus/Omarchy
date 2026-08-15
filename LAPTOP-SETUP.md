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
- ✓ Abre el editor para adaptar monitores y la salida de Waybar
- ✓ Pregunta confirmación antes de sobrescribir

## ⚙️ Configuración específica de portátil

### 1. Monitores (CRÍTICO)
El instalador abre estas configuraciones después de desplegar y validar los symlinks:
- `hypr/.config/hypr/monitors.lua`
- `waybar/.config/waybar/config.jsonc`

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

# Verificar waybar
pkill waybar && waybar &
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
- ✓ Waybar (Material You theme)
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

### Waybar no aparece
- Verifica en `waybar/config.jsonc` el `output` (debe ser tu monitor principal)

### Permisos de clave pública SSH
```bash
chmod 644 ~/.ssh/id_ed25519.pub
```

La clave privada se gestiona manualmente fuera de este repositorio.

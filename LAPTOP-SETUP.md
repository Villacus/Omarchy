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
- ✓ Pregunta confirmación antes de sobrescribir

## ⚙️ Configuración específica de portátil

### 1. Monitores (CRÍTICO)
```bash
# Editar según tu hardware
nvim ~/dotfiles/hypr/.config/hypr/monitors.lua

# Ver monitores disponibles:
hyprctl monitors
```

### 2. Wallpaper Engine (OPCIONAL)
Si no tienes Steam/Wallpaper Engine, comenta estas líneas en:
- `hypr/.config/hypr/autostart.lua` → línea de `restore-wallpapers`
- O edita `scripts/.config/scripts/restore-wallpapers` para solo cargar fondos estáticos

### 3. Rutas hardcoded a revisar
- `/mnt/Games/SteamLibrary/` en scripts de wallpaper-engine
- Ajusta según tu instalación de Steam

### 4. SSH Keys
Las claves SSH se symlinkarán desde el repo. Si ya tienes keys:
```bash
# Copiar keys existentes AL repo antes de instalar
cp ~/.ssh/id_ed25519* ~/dotfiles/ssh/.ssh/
```

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
- ✓ SSH keys
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

### Permisos SSH
```bash
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

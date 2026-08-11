# Auditoría de Dotfiles - 2026-08-11

## ✅ Configuraciones YA en el repo
- `bash/.bashrc` → symlinked ✓
- `git/.gitconfig` → symlinked ✓
- `ssh/.ssh/` → parcialmente symlinked (keys sí, known_hosts no debería estar)
- `opencode/.opencode` → symlinked ✓
- `hypr/.config/hypr/` → **NO symlinked, copiado directamente**
- `waybar/.config/waybar/` → **NO symlinked, copiado directamente**
- `scripts/.config/scripts/` → **NO symlinked, copiado directamente**
- `omarchy-extensions/.config/omarchy/extensions/` → **NO symlinked, copiado directamente**

## 📋 Configuraciones importantes que FALTAN en el repo

### Críticas (llevar al portátil):
- `~/.config/starship.toml` — configuración de prompt
- `~/.config/alacritty/alacritty.toml` — terminal emulator
- `~/.config/fastfetch/config.jsonc` — system info
- `~/.config/btop/btop.conf` — monitor de sistema
- `~/.config/mimeapps.list` — aplicaciones por defecto
- `~/.config/xdg-terminals.list` — configuración de terminal por defecto
- `~/.config/chromium-flags.conf` y `chrome-flags.conf` — flags de navegadores

### Opcionales (dependiendo de qué uses en clase):
- `~/.config/cliamp/` — reproductor de música
- `~/.config/imv/` — visor de imágenes
- `~/.config/environment.d/` — variables de entorno
- `~/.config/git/` — configuración adicional de git

## 🗑️ Archivos a limpiar del repo
- `ssh/.ssh/known_hosts` y `known_hosts.bak` — específicos de esta máquina
- `hypr/.config/hypr/*.bak.*` — backups temporales
- `hypr/.config/hypr/.luarc.json` — configuración de LSP local

## 🔧 Problemas actuales con stow
1. Los directorios en `~/.config/` son copias, no symlinks
2. Cambios en el repo no se reflejan automáticamente
3. `ssh/` tiene conflictos con `known_hosts`

## 📦 Paquetes stow a configurar
- `bash`
- `git`
- `ssh` (solo keys y config, no known_hosts)
- `opencode`
- `hypr`
- `waybar`
- `scripts`
- `omarchy-extensions`
- `starship` (nuevo)
- `alacritty` (nuevo)
- `fastfetch` (nuevo)
- `btop` (nuevo)
- `mimeapps` (nuevo)

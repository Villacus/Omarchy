# ✅ Dotfiles configurados con GNU Stow

## 📊 Resumen de cambios

### ✨ Nuevas configuraciones añadidas
- **alacritty** — Emulador de terminal
- **btop** — Monitor de sistema con tema
- **fastfetch** — System info
- **starship** — Prompt personalizado
- **mimeapps** — Aplicaciones por defecto

### 🔧 Sistema stow configurado
- ✅ Todos los directorios en `~/.config/` ahora son **symlinks**
- ✅ Cambios en el repo se reflejan automáticamente
- ✅ Archivos `.stow-local-ignore` para excluir temporales
- ✅ SSH configurado para excluir `known_hosts`

### 📜 Scripts de automatización
- `install.sh` — Instalación con backups automáticos
- `uninstall.sh` — Desinstalación limpia
- Ambos con colores y confirmaciones

### 📚 Documentación
- `AUDIT.md` — Lista de qué está y qué falta en dotfiles
- `LAPTOP-SETUP.md` — Guía paso a paso para portátil
- `README.md` — Actualizado con instrucciones de instalación
- `CLAUDE.md` — Documentación técnica completa

## 🎯 Para pasar al portátil

```bash
# 1. En el portátil nuevo:
git clone <tu-repo-url> ~/dotfiles
cd ~/dotfiles

# 2. Revisar hardware-specific config:
nvim hypr/.config/hypr/monitors.lua  # ⚠️ CRÍTICO: ajustar monitores

# 3. Instalar:
./install.sh

# 4. Recargar Hyprland:
hyprctl reload
```

## 📦 Paquetes incluidos (13 total)

1. bash
2. git
3. ssh
4. opencode
5. hypr
6. scripts
7. omarchy
8. omarchy-extensions
9. alacritty
10. btop
11. fastfetch
12. starship
13. mimeapps

El paquete `omarchy` contiene la configuración activa de Quickshell en `~/.config/omarchy/shell.json`. Waybar fue retirado tras la migración a Quattro.

## ⚠️ Importante para portátil

### Antes de instalar:
- [ ] Instalar `stow`: `sudo pacman -S stow`
- [ ] Instalar Omarchy (si no está)

### Después de instalar:
- [ ] Editar `monitors.lua` según hardware del portátil
- [ ] Si no tienes Wallpaper Engine, comentar `restore-wallpapers` en `autostart.lua`
- [ ] Verificar paths de Steam en scripts (si usas wallpapers animados)

## 🔄 Flujo de trabajo

Los cambios ahora son **bidireccionales**:
- Editas en `~/dotfiles/` → Se refleja en `~/.config/`
- Sistema usa `~/.config/` → Son symlinks a `~/dotfiles/`

```bash
# Hacer cambios
cd ~/dotfiles
nvim hypr/.config/hypr/bindings.lua

# Guardar, recargar, commit
hyprctl reload
git add -A
git commit -m "Update bindings"
git push
```

## 🎉 Estado actual

- ✅ Sistema actual funcionando con symlinks
- ✅ Commit creado: `6b0dee5`
- ✅ Listo para push y clone en portátil
- ✅ Backup de seguridad en `/tmp/config-backup-*.tar.gz`

## 🚀 Siguiente paso

```bash
git push origin main
```

Y en el portátil solo necesitas clonar y ejecutar `./install.sh`.

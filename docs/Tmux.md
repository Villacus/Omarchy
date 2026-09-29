# Tmux en Omarchy

Multiplexor de terminal [Tmux](https://github.com/tmux/tmux) configurado para maximizar la productividad y permitir sesiones persistentes, especialmente útil al trabajar con servidores remotos del homelab.

## Configuración y Características

La configuración central se encuentra en `tmux.conf` y está ajustada para:

- **Entornos de Desarrollo**: Gestión rápida de ventanas y paneles.
- **Integración con el Sistema**: Soporte configurado para el portapapeles del sistema, facilitando copiar y pegar entre sesiones locales y remotas.
- **Atajos Personalizados**: Optimización de la navegación y gestión de sesiones.

## Uso en el Homelab

Tmux es fundamental para el mantenimiento del entorno de homelab. Permite mantener sesiones activas en la Raspberry Pi (pilla) mediante SSH, asegurando que los procesos de despliegue o logs no se interrumpan al cerrar la conexión.

Véase [[Despliegue|Despliegue de Servicios]] para el flujo de trabajo estándar utilizando Tmux sobre SSH.

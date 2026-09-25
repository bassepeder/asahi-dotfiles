# Auto-start Sway on the first virtual terminal, no display manager.
if [ -z "${WAYLAND_DISPLAY:-}" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec sway
fi

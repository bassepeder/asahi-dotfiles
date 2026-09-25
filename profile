# Symlinked to .bash_profile, .zprofile and .profile, whichever login shell
# reads it — bash reads .bash_profile, not .zprofile, and doesn't source
# .bashrc for login shells on its own.
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

# rust-analyzer (rustup) and the npm-installed LSP servers live here.
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

# Force dark mode for GTK/Qt apps regardless of theme/gsettings state.
export GTK_THEME=Adwaita:dark
export QT_QPA_PLATFORMTHEME=gtk3

# Auto-start Sway on the first virtual terminal, no display manager.
if [ -z "${WAYLAND_DISPLAY:-}" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec sway
fi

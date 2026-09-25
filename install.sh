#!/usr/bin/env bash
set -euo pipefail

# Installs packages via dnf and symlinks this repo into place. Self-locating:
# everything is derived from where this script lives, so the repo works from
# any path.

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing from $DOTFILES"
echo

# ------------------------------------------------------------------ dnf ---

if command -v dnf >/dev/null 2>&1; then
  echo "Installing packages (sudo dnf install)..."
  # --setopt=strict=0: skip packages dnf can't find instead of aborting the
  # whole transaction (cool-retro-term is the one most likely to be missing).
  # shellcheck disable=SC2046
  sudo dnf install -y --setopt=strict=0 $(grep -v '^#' "$DOTFILES/packages.txt")
  echo
else
  echo "⚠️  dnf not found — skipping package install." >&2
fi

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
if command -v fc-list >/dev/null 2>&1 && ! fc-list | grep -qi "c64 pro mono"; then
  echo "Fetching C64 Pro Mono..."
  tmp="$(mktemp -d)"
  curl -sL -o "$tmp/c64tt.zip" "https://style64.org/file/C64_TrueType_v1.2.1-STYLE.zip"
  unzip -o -q "$tmp/c64tt.zip" -d "$tmp"
  cp "$tmp"/C64_TrueType_*-STYLE/fonts/*.ttf "$FONT_DIR/"
  rm -rf "$tmp"
  fc-cache -f "$FONT_DIR" >/dev/null
  echo "Installed to $FONT_DIR"
fi

# ----------------------------------------------------------- stale links ---
#
# Clear symlinks that point into this repo before relinking. Only ever removes
# links into this repo — never a real file, never someone else's link.

MANAGED_LINKS=(
  "$HOME/.config/sway"
  "$HOME/.config/waybar"
  "$HOME/.config/mako"
  "$HOME/.config/nvim"
  "$HOME/.config/gtk-3.0"
  "$HOME/.config/gtk-4.0"
  "$HOME/.bash_profile"
  "$HOME/.zprofile"
  "$HOME/.profile"
)

cleared=0
for link in "${MANAGED_LINKS[@]}"; do
  [ -L "$link" ] || continue
  case "$(readlink "$link")" in
    "$DOTFILES"/*) rm "$link"; cleared=$((cleared + 1)) ;;
  esac
done
[ "$cleared" -gt 0 ] && echo "Cleared $cleared symlink(s) from a previous install."

# --------------------------------------------------------------- symlinks ---

backup() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.backup.$(date +%s)"
    echo "Backed up $target"
  fi
}

mkdir -p ~/.config ~/.local/share/fonts ~/Pictures

backup ~/.config/sway
ln -sfn "$DOTFILES/sway" ~/.config/sway

backup ~/.config/waybar
ln -sfn "$DOTFILES/waybar" ~/.config/waybar

backup ~/.config/mako
ln -sfn "$DOTFILES/mako" ~/.config/mako

backup ~/.config/nvim
ln -sfn "$DOTFILES/simplified_nvim" ~/.config/nvim

backup ~/.config/gtk-3.0
ln -sfn "$DOTFILES/gtk-3.0" ~/.config/gtk-3.0
backup ~/.config/gtk-4.0
ln -sfn "$DOTFILES/gtk-4.0" ~/.config/gtk-4.0

# Symlinked to all three so it's read regardless of the account's login
# shell (bash reads .bash_profile, zsh reads .zprofile, sh/others read
# .profile).
backup ~/.bash_profile
ln -sfn "$DOTFILES/profile" ~/.bash_profile
backup ~/.zprofile
ln -sfn "$DOTFILES/profile" ~/.zprofile
backup ~/.profile
ln -sfn "$DOTFILES/profile" ~/.profile

# ------------------------------------------------- simplified_nvim toolchain ---
# LSP servers from simplified_nvim/README.md that dnf doesn't package.

export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

if command -v rustup >/dev/null 2>&1; then
  echo
  echo "Installing rust-analyzer (rustup)..."
  rustup toolchain install stable --profile minimal -c rust-analyzer
  rustup default stable
fi

if command -v npm >/dev/null 2>&1; then
  echo
  echo "Installing vtsls/vscode-langservers-extracted/oxlint/tree-sitter-cli (npm)..."
  npm config set prefix "$HOME/.local"
  npm install -g @vtsls/language-server vscode-langservers-extracted oxlint tree-sitter-cli
fi

# ---------------------------------------------------------------- reload ---
# If Sway is already running, apply everything live instead of requiring a
# logout. `swaymsg reload` alone doesn't restart plain `exec` processes (only
# `exec_always` ones), so waybar/mako/polkit are killed and relaunched too.
# This never touches the sway process itself — killing that would take down
# this very terminal along with everything else open.

if [ -n "${SWAYSOCK:-}" ] && command -v swaymsg >/dev/null 2>&1; then
  echo
  echo "Sway is running — reloading config and restarting waybar/mako..."
  swaymsg reload
  pkill -x waybar 2>/dev/null || true
  pkill -x mako 2>/dev/null || true
  pkill -x polkit-gnome-authentication-agent-1 2>/dev/null || true
  setsid waybar >/dev/null 2>&1 < /dev/null &
  setsid mako >/dev/null 2>&1 < /dev/null &
  setsid /usr/libexec/polkit-gnome-authentication-agent-1 >/dev/null 2>&1 < /dev/null &
  disown -a
  echo "Reloaded live."
else
  echo
  echo "Sway isn't running yet — log out and back in on tty1 to start it."
fi

echo
echo "✅ Dotfiles installed from $DOTFILES"

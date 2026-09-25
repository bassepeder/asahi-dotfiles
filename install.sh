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

# Confirmed present in Fedora's own repos (Fedora 43/44/45) as "cool-retro-term",
# so this should never fire on a normal Fedora Asahi Remix install.
if ! command -v cool-retro-term >/dev/null 2>&1; then
  cat <<'EOF'
⚠️  cool-retro-term did not install. Build from source if needed:
    https://github.com/Swordfish90/cool-retro-term
EOF
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
  "$HOME/.config/cool-retro-term/profiles/basse_terminal.json"
  "$HOME/.config/gtk-3.0"
  "$HOME/.config/gtk-4.0"
  "$HOME/.zprofile"
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

mkdir -p ~/.config ~/.config/cool-retro-term/profiles ~/Pictures

backup ~/.config/sway
ln -sfn "$DOTFILES/sway" ~/.config/sway

backup ~/.config/waybar
ln -sfn "$DOTFILES/waybar" ~/.config/waybar

backup ~/.config/mako
ln -sfn "$DOTFILES/mako" ~/.config/mako

backup ~/.config/nvim
ln -sfn "$DOTFILES/simplified_nvim" ~/.config/nvim

backup ~/.config/cool-retro-term/profiles/basse_terminal.json
ln -sfn "$DOTFILES/cool-retro-term/basse_terminal.json" ~/.config/cool-retro-term/profiles/basse_terminal.json

backup ~/.config/gtk-3.0
ln -sfn "$DOTFILES/gtk-3.0" ~/.config/gtk-3.0
backup ~/.config/gtk-4.0
ln -sfn "$DOTFILES/gtk-4.0" ~/.config/gtk-4.0

backup ~/.zprofile
ln -sfn "$DOTFILES/zprofile" ~/.zprofile

echo
echo "✅ Dotfiles installed from $DOTFILES"
echo "Log out and back in on tty1 — .zprofile execs sway automatically."

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

if ! command -v cool-retro-term >/dev/null 2>&1; then
  cat <<'EOF'
⚠️  cool-retro-term did not install from Fedora's repos. Try a COPR, or build
    from source: https://github.com/Swordfish90/cool-retro-term
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
  "$HOME/.gitconfig"
  "$HOME/.gitignore_global"
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

backup ~/.gitconfig
ln -sfn "$DOTFILES/git/gitconfig" ~/.gitconfig
backup ~/.gitignore_global
ln -sfn "$DOTFILES/git/gitignore_global" ~/.gitignore_global

backup ~/.zprofile
ln -sfn "$DOTFILES/zprofile" ~/.zprofile

if command -v git-lfs >/dev/null 2>&1; then
  git lfs install --skip-repo
fi

echo
echo "✅ Dotfiles installed from $DOTFILES"
echo "Log out and back in on tty1 — .zprofile execs sway automatically."

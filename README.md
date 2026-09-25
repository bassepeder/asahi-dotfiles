# asahi-dotfiles

Dotfiles for Fedora Asahi Remix (Minimal) on an M1 Pro. Sway, styled and
keybound like i3, no display manager.

## Install

```bash
git clone https://github.com/bassepeder/asahi-dotfiles.git ~/asahi-dotfiles
cd ~/asahi-dotfiles && ./install.sh
```

Installs everything in `packages.txt` via `dnf`, then symlinks configs into
place. Log out and back in on tty1 — `zprofile` execs `sway` directly, no
greeter.

## Layout

| | |
|---|---|
| [`sway/`](sway) | compositor config — i3 keybinds, mod4 |
| [`waybar/`](waybar) | status bar, styled to look like plain i3bar (flat, no icons) |
| [`mako/`](mako) | notifications |
| [`simplified_nvim/`](simplified_nvim) | Neovim, copied from `~/dotfiles` |
| [`cool-retro-term/`](cool-retro-term) | terminal profile (C64 font), copied from `~/dotfiles` |
| [`git/`](git) | personal gitconfig (bastian.tangedal@gmail.com), ported from `~/dotfiles/nixos` |
| `zprofile` | execs `sway` on tty1 login |
| `packages.txt` | dnf package list |

## Keybinds

Mod is Super/Cmd. Everything else matches i3: `$mod+Return` terminal,
`$mod+d` launcher (wofi), `$mod+shift+q` kill, `$mod+hjkl`/arrows focus,
`$mod+shift+hjkl`/arrows move, `$mod+1..0` workspaces, `$mod+b`/`v` split,
`$mod+f` fullscreen, `$mod+r` resize mode, `$mod+shift+e` exit.

## Notes

- Terminal is always launched as `cool-retro-term -p basse_terminal`
  (see `sway/config`) rather than relying on a saved "last profile."
- Keyboard layout is set to Norwegian (`no`), matching the other machine
  config in `~/dotfiles/nixos`. Change it in `sway/config` if that's wrong
  for this keyboard.
- `git/gitconfig` is the personal identity (gmail), separate from the ABAX
  one on the macOS machine.

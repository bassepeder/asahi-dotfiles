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
| [`gtk-3.0/`](gtk-3.0), [`gtk-4.0/`](gtk-4.0) | force dark theme for GTK apps |
| `zprofile` | execs `sway` on tty1 login, forces dark mode env vars |
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
- Dark mode is forced system-wide: `gsettings` (color-scheme + gtk-theme),
  `GTK_THEME`/`QT_QPA_PLATFORMTHEME` env vars in `zprofile`, and
  `gtk-3.0`/`gtk-4.0` `settings.ini` as a fallback for apps that don't read
  gsettings.
- `cool-retro-term` is in Fedora's own repos (confirmed present in Fedora
  43/44/45), so `packages.txt` installs it directly — no COPR needed.

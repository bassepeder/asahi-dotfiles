# asahi-dotfiles

Dotfiles for Fedora Asahi Remix (Minimal) on an M1 Pro. Sway, styled and
keybound like i3, no display manager.

## Install

```bash
git clone https://github.com/bassepeder/asahi-dotfiles.git ~/asahi-dotfiles
cd ~/asahi-dotfiles && ./install.sh
```

Installs everything in `packages.txt` via `dnf`, then symlinks configs into
place. Log out and back in on tty1 — `profile` (symlinked to
`.bash_profile`/`.zprofile`/`.profile`, whichever your login shell reads)
execs `sway` directly, no greeter.

## Layout

| | |
|---|---|
| [`sway/`](sway) | compositor config — i3 keybinds, mod4 |
| [`waybar/`](waybar) | status bar, styled to look like plain i3bar (flat, no icons) |
| [`mako/`](mako) | notifications |
| [`simplified_nvim/`](simplified_nvim) | Neovim, copied from `~/dotfiles` |
| [`cool-retro-term/`](cool-retro-term) | terminal profile (C64 font), copied from `~/dotfiles` |
| [`gtk-3.0/`](gtk-3.0), [`gtk-4.0/`](gtk-4.0) | force dark theme for GTK apps |
| `profile` | execs `sway` on tty1 login, forces dark mode env vars — symlinked to `.bash_profile`/`.zprofile`/`.profile` |
| `packages.txt` | dnf package list |

## Keybinds

Mod is Super/Cmd. Everything else matches i3: `$mod+Return` terminal,
`$mod+d` launcher (wofi), `$mod+shift+q` kill, `$mod+hjkl`/arrows focus,
`$mod+shift+hjkl`/arrows move, `$mod+1..0` workspaces, `$mod+b`/`v` split,
`$mod+f` fullscreen, `$mod+r` resize mode, `$mod+shift+e` exit.

## Notes

- Terminal is launched as `cool-retro-term --profile basse_terminal` (see
  `sway/config`) — must be the long `--profile` flag; cool-retro-term's `-p`
  is documented in `--help` but not actually wired up in its arg parser.
  **One-time manual step required:** cool-retro-term has no directory it
  scans for profile files — a profile only becomes selectable by name after
  you import it once through the GUI. Launch `cool-retro-term`, open
  Settings → General → Import, pick `~/.config/cool-retro-term/profiles/
  basse_terminal.json`, then quit the app normally (it persists custom
  profiles to its internal storage on quit, not on import). After that,
  `--profile basse_terminal` will find it on every future launch.
- Keyboard layout is set to Norwegian (`no`), matching the other machine
  config in `~/dotfiles/nixos`. Change it in `sway/config` if that's wrong
  for this keyboard.
- Dark mode is forced system-wide: `gsettings` (color-scheme + gtk-theme),
  `GTK_THEME`/`QT_QPA_PLATFORMTHEME` env vars in `profile`, and
  `gtk-3.0`/`gtk-4.0` `settings.ini` as a fallback for apps that don't read
  gsettings.
- `profile` is symlinked to `.bash_profile`, `.zprofile` and `.profile`
  because only zsh reads `.zprofile` — bash (the default login shell on a
  fresh Fedora account) reads `.bash_profile` instead, so a bare `.zprofile`
  silently never runs and Sway never auto-starts.
- `cool-retro-term` is in Fedora's own repos (confirmed present in Fedora
  43/44/45), so `packages.txt` installs it directly — no COPR needed.
- `simplified_nvim`'s LSP servers aren't dnf packages; `install.sh` installs
  rust-analyzer via `rustup` and vtsls/vscode-langservers-extracted/
  oxlint/tree-sitter-cli via `npm`, and `packages.txt`/`profile` add the
  `gcc`/`make` toolchain and `~/.cargo/bin`+`~/.local/bin` to `PATH` that
  those need (native builds for blink.cmp and treesitter parsers, plus the
  npm global-install location). The brew commands in
  `simplified_nvim/README.md` don't apply here — `install.sh` already
  covers them.

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
| [`waybar/`](waybar) | status bar — just workspaces + clock, styled flat/plain like i3bar |
| [`mako/`](mako) | notifications |
| [`simplified_nvim/`](simplified_nvim) | Neovim, copied from `~/dotfiles` |
| [`gtk-3.0/`](gtk-3.0), [`gtk-4.0/`](gtk-4.0) | force dark theme for GTK apps |
| `profile` | execs `sway` on tty1 login, forces dark mode env vars — symlinked to `.bash_profile`/`.zprofile`/`.profile` |
| `packages.txt` | dnf package list |

## Keybinds

Mod is Super/Cmd. Everything else matches i3: `$mod+Return` terminal,
`$mod+d` launcher (wofi), `$mod+shift+q` kill, `$mod+hjkl`/arrows focus,
`$mod+shift+hjkl`/arrows move, `$mod+1..0` workspaces, `$mod+b`/`v` split,
`$mod+f` fullscreen, `$mod+r` resize mode, `$mod+shift+e` exit.

## Notes

- Terminal is `st` (suckless terminal), launched as
  `st -f "C64 Pro Mono:size=14"` (see `sway/config`) — `-f` is a stock,
  unpatched st flag, no rebuild needed. `st` is in Fedora's own repos
  (43/44/45), no COPR needed.
  **One-time manual step required:** the C64 TrueType font's license
  explicitly forbids scripted/automated download, so `install.sh` can't
  fetch it — grab it yourself from https://style64.org/c64-truetype, unzip,
  drop the `.ttf` files in `~/.local/share/fonts/`, then run `fc-cache -f`.
  `install.sh` checks for it and reminds you if it's missing.
  We moved off cool-retro-term for two confirmed, unfixable-in-config
  reasons: it never implements cursor-shape switching (open upstream
  request, still unresolved: https://github.com/Swordfish90/cool-retro-term/issues/785),
  so nvim's insert-mode cursor never changed; and it has its own bug
  sending Option-modified characters with a spurious ESC (Meta) prefix
  (https://github.com/Swordfish90/cool-retro-term/issues/962), which in
  nvim would drop you out of insert mode and misfire the character as a
  command. `st` is a plain, mature Xlib terminal — it doesn't have either
  problem, and natively implements DECSCUSR (confirmed in its source, no
  patch required). It's an X11 app, but runs fine under Sway via XWayland
  (already in `packages.txt`).
- Keyboard layout is set to Norwegian (`no`), matching the other machine
  config in `~/dotfiles/nixos`. Change it in `sway/config` if that's wrong
  for this keyboard.
- `xkb_model applealu_ansi` is required for Apple keyboards, this laptop's
  built-in one included — it maps physical keys to the right scancodes on
  this hardware. This is Asahi's own documented fix, not a workaround we
  invented: https://asahilinux.org/docs/sw/keyboard-layouts/.
- AltGr (level 3: `{` `}` `[` `]` etc.) is **Left Option**, via
  `xkb_options lv3:lalt_switch` — Right Alt is AltGr by default on any
  PC/`no` layout with no config at all, but Left Option was moved into that
  role by preference. Left Option is no longer plain Alt as a result. On
  the Norwegian layout the symbols are AltGr+7/0/8/9 for `{`/`}`/`[`/`]` —
  not Option+Shift like on macOS. Linux doesn't (and can't correctly)
  emulate macOS's own shortcut scheme; this is the real Linux/XKB mapping
  for this layout on a PC-style keyboard.
- Dark mode is forced system-wide: `gsettings` (color-scheme + gtk-theme),
  `GTK_THEME`/`QT_QPA_PLATFORMTHEME` env vars in `profile`, and
  `gtk-3.0`/`gtk-4.0` `settings.ini` as a fallback for apps that don't read
  gsettings.
- `profile` is symlinked to `.bash_profile`, `.zprofile` and `.profile`
  because only zsh reads `.zprofile` — bash (the default login shell on a
  fresh Fedora account) reads `.bash_profile` instead, so a bare `.zprofile`
  silently never runs and Sway never auto-starts.
- `simplified_nvim`'s LSP servers aren't dnf packages; `install.sh` installs
  rust-analyzer via `rustup` and vtsls/vscode-langservers-extracted/
  oxlint/tree-sitter-cli via `npm`, and `packages.txt`/`profile` add the
  `gcc`/`make` toolchain and `~/.cargo/bin`+`~/.local/bin` to `PATH` that
  those need (native builds for blink.cmp and treesitter parsers, plus the
  npm global-install location). The brew commands in
  `simplified_nvim/README.md` don't apply here — `install.sh` already
  covers them.

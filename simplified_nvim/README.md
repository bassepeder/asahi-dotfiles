# simplified_nvim

Minimal Neovim config: LSP (Scala, TypeScript, Rust, C, HTML, CSS/SCSS),
sane defaults, a colorscheme, a fuzzy finder, and a file explorer. No
framework — plugins are installed with Neovim 0.12's built-in `vim.pack`.

## Use it

```sh
ln -s ~/dotfiles/simplified_nvim ~/.config/simplified_nvim
NVIM_APPNAME=simplified_nvim nvim
```

## Install LSP server binaries

No Mason — install these yourself:

```sh
rustup component add rust-analyzer
brew install llvm            # clangd
npm i -g @vtsls/language-server
npm i -g vscode-langservers-extracted   # cssls + html
npm i -g oxlint
brew install tree-sitter-cli   # `tree-sitter` formula is library-only now
```

Metals (Scala) bootstraps itself via Coursier on first attach to a
`.scala`/`.sbt` file.

## Keymaps

| Key | Action |
|-----|--------|
| `gd` / `gD` | Go to definition / declaration |
| `gr` | Find references |
| `gI` | Go to implementation |
| `K` | Hover |
| `<leader>ff` | Find files (root dir) |
| `<leader>fg` | Grep (root dir) |
| `<space>e` | File explorer |
| `<leader>cf` | Format |
| `<leader>gg` | Lazygit |
| `<leader>tt` | Toggle terminal (floating, project root) |
| `<leader>xx` | Diagnostics list (Trouble) |

Everything else is in `lua/keymaps.lua`.

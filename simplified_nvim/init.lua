vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/scalameta/nvim-metals",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/saghen/blink.lib",
  "https://github.com/saghen/blink.cmp",
  "https://github.com/folke/snacks.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/echasnovski/mini.icons",
  "https://github.com/miikanissi/modus-themes.nvim",
  "https://github.com/f-person/auto-dark-mode.nvim",
  "https://github.com/folke/trouble.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/kdheepak/lazygit.nvim",
})

require("options")
require("plugins")
require("lsp")
require("keymaps")
require("autocmds")
require("statusline")

if vim.g.neovide then
  require("neovide")
end

require("nvim-treesitter").install({
  "scala",
  "rust",
  "c",
  "typescript",
  "tsx",
  "html",
  "css",
  "scss",
  "lua",
  "vim",
  "vimdoc",
  "markdown",
})
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

local cmp = require("blink.cmp")
cmp.build():pwait()
cmp.setup({
  keymap = { preset = "enter" },
  sources = { default = { "lsp", "path", "buffer" } },
  completion = {
    documentation = { auto_show = true },
    ghost_text = { enabled = true },
  },
})

require("mini.icons").setup()

require("which-key").setup({
  icons = { mappings = false },
})

require("snacks").setup({
  explorer = {},
  picker = {
    enabled = true,
    win = {
      input = {
        keys = {
          ["<tab>"] = { "list_down", mode = { "i", "n" } },
          ["<s-tab>"] = { "list_up", mode = { "i", "n" } },
        },
      },
      list = {
        keys = {
          ["<tab>"] = "list_down",
          ["<s-tab>"] = "list_up",
        },
      },
    },
  },
})

require("trouble").setup({
  keys = {
    ["<tab>"] = "next",
    ["<s-tab>"] = "prev",
  },
})

require("modus-themes").setup({
  style = "auto",
  variants = {
    modus_operandi = "deuteranopia",
    modus_vivendi = "deuteranopia",
  },
})
vim.cmd.colorscheme("modus")

require("auto-dark-mode").setup({
  set_dark_mode = function()
    if vim.o.background ~= "dark" then
      vim.o.background = "dark"
      vim.cmd.colorscheme("modus")
    end
  end,
  set_light_mode = function()
    if vim.o.background ~= "light" then
      vim.o.background = "light"
      vim.cmd.colorscheme("modus")
    end
  end,
})

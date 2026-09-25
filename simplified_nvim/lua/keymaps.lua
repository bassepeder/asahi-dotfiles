local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

local function root()
  return vim.fs.root(0, ".git") or vim.uv.cwd()
end

-- LSP
map("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
map("n", "gr", function()
  require("snacks").picker.lsp_references()
end, { desc = "References" })
map("n", "gI", function()
  require("snacks").picker.lsp_implementations()
end, { desc = "Goto Implementation" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map({ "n", "v" }, "<leader>cf", function()
  _G.lsp_format(0)
end, { desc = "Format" })

-- diagnostics
local function diagnostic_goto(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Metals
map("n", "<leader>mc", function()
  require("metals").compile_cascade()
end, { desc = "Metals compile cascade" })
map("n", "<leader>me", function()
  require("metals").commands()
end, { desc = "Metals menu" })

-- finder / grep (always root dir)
map("n", "<leader>ff", function()
  require("snacks").picker.files({ cwd = root() })
end, { desc = "Find Files (Root Dir)" })
map("n", "<leader>fg", function()
  require("snacks").picker.grep({ cwd = root() })
end, { desc = "Grep (Root Dir)" })

-- explorer
map("n", "<space>e", function()
  require("snacks").explorer()
end, { desc = "Explorer" })

-- git
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Lazygit" })

-- terminal
map({ "n", "t" }, "<leader>tt", function()
  require("snacks").terminal.toggle(nil, { cwd = root() })
end, { desc = "Toggle Terminal" })

-- diagnostics list
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })

-- window nav
map("n", "<leader>n", "<C-w>h", { desc = "Go to left window" })
map("n", "<leader>e", "<C-w>l", { desc = "Go to right window" })
map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wo", "<cmd>only<cr>", { desc = "Close other windows" })
map("n", "<leader>wd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })

-- buffers
map("n", "<leader>md", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- tabs
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

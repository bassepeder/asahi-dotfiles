vim.opt.laststatus = 3
vim.opt.statusline = table.concat({
  " %{mode()}",
  " %f%m",
  "%=",
  "%{get(g:, 'metals_status', '')}",
  " %-14.(%l,%c%V%) %P ",
}, " ")

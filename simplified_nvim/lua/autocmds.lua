vim.cmd([[
  au BufRead,BufNewFile */conf/\(*\|\)routes set filetype=play2-routes
  au BufRead,BufNewFile */conf/*.conf setf hocon
]])

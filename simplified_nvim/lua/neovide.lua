vim.g.neovide_floating_corner_radius = 0.5
vim.g.neovide_proxy_icon = true

vim.o.guifont = "JetBrainsMono Nerd Font Mono:h13"

vim.g.neovide_cursor_animation_length = 0.15
vim.g.neovide_cursor_short_animation_length = 0.25
vim.g.neovide_cursor_trail_size = 0.9
vim.g.neovide_cursor_unfocused_outline_width = 0.125

vim.g.neovide_cursor_vfx_mode = { "railgun", "pixiedust" }
vim.g.neovide_cursor_vfx_particle_lifetime = 0.7

vim.g.neovide_hide_mouse_when_typing = true

local function paste()
  vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
end

vim.keymap.set({ "v", "c", "t" }, "<C-v>", paste, {
  silent = true,
  desc = "Paste",
})

local function change_scale_factor(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
end

vim.keymap.set("n", "<C-ScrollWheelUp>", function()
  change_scale_factor(0.05)
end)

vim.keymap.set("n", "<C-ScrollWheelDown>", function()
  change_scale_factor(-0.05)
end)

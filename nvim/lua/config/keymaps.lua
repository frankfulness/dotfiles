-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Home key to return to dashboard
vim.keymap.set("n", "<Home>", function()
  Snacks.dashboard.open()
end, { desc = "Return to dashboard" })

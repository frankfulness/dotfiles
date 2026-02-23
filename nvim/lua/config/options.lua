-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Make main background transparent
local function set_transparent_bg()
  -- Main editor background
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  -- File tree (Neo-tree) background
  vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
  -- Non-current window background (for file content)
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  
  vim.cmd([[highlight Normal guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight NeoTreeNormal guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight NeoTreeNormalNC guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight NormalNC guibg=NONE ctermbg=NONE]])
end

-- Apply transparency on multiple events to ensure it sticks
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter", "BufWinEnter" }, {
  pattern = "*",
  callback = set_transparent_bg,
})

-- Apply transparency immediately
set_transparent_bg()

-- Also apply after a short delay to override LazyVim
vim.defer_fn(set_transparent_bg, 100)

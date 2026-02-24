return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- shows hidden files as dimmed
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
  },
}

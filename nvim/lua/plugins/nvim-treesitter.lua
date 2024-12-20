return {
  "nvim-treesitter/nvim-treesitter",
  install = {
    prefer_git = false,
    compilers = { "zig" },
  },
  opts = { ensure_installed = { "rust", "ron", "http", "graphql" } },
}

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>l", group = "LSP" },
      { "<leader>m", group = "Markdown" },
      { "<leader>o", group = "OpenCode" },
      { "<leader>t", group = "Terminal" },
    },
  },
}

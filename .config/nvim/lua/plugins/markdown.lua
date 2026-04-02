return {
  "iamcco/markdown-preview.nvim",
  build = "cd app && npm install",
  ft = "markdown",
  keys = {
    { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", ft = "markdown", desc = "Markdown preview" },
  },
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_auto_close = 1
  end,
  config = function()
    -- Plugin registers buffer-local commands via a BufEnter autocommand.
    -- After lazy-loading, we need to re-trigger it for the current buffer.
    vim.cmd("doautocmd mkdp_init BufEnter")
  end,
}

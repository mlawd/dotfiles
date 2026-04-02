return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function(_, opts)
    require("nvim-treesitter").setup(opts)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
      callback = function(event)
        pcall(vim.treesitter.start, event.buf)
      end,
    })
  end,
  opts = {
    ensure_installed = {
      "go",
      "gomod",
      "gosum",
      "typescript",
      "tsx",
      "javascript",
      "vue",
      "svelte",
      "lua",
      "vim",
      "vimdoc",
      "markdown",
      "markdown_inline",
      "html",
      "css",
      "json",
      "yaml",
      "toml",
      "bash",
      "regex",
      "diff",
      "gitcommit",
    },
    highlight = { enable = true },
    indent = { enable = true },
    auto_install = true,
  },
}

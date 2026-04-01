return {
  "sudo-tee/opencode.nvim",
  config = function()
    require("opencode").setup({
      preferred_picker = "telescope",
      preferred_completion = "blink",
      default_global_keymaps = true,
      default_mode = "plan",
      keymap_prefix = "<leader>o",
    })
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        anti_conceal = { enabled = false },
        file_types = { "markdown", "opencode_output" },
      },
      ft = { "markdown", "opencode_output" },
    },
    "saghen/blink.cmp",
    "nvim-telescope/telescope.nvim",
  },
}

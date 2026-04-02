return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle filesystem reveal left<CR>", desc = "Toggle explorer" },
    { "-", "<cmd>Neotree reveal filesystem left<CR>", desc = "Reveal in explorer" },
    { "<leader>bf", "<cmd>Neotree toggle buffers right<CR>", desc = "Toggle buffer explorer" },
    { "<leader>gg", "<cmd>Neotree toggle git_status right<CR>", desc = "Toggle git explorer" },
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      popup_border_style = "rounded",
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = "open_default",
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        width = 32,
        mappings = {
          ["<leader>e"] = "close_window",
          ["H"] = "toggle_hidden",
          ["l"] = "open",
          ["h"] = "close_node",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path)
            end,
            desc = "Copy path to clipboard",
          },
          ["O"] = "open_with_window_picker",
          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["<bs>"] = "navigate_up",
        },
      },
    })
  end,
}

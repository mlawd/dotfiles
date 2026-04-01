return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Hunk navigation
        map("n", "]h", function() gs.nav_hunk("next") end, "Next git hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Previous git hunk")

        -- Actions
        map("n", "<leader>gp", function() gs.preview_hunk() end, "Preview hunk")
        map("n", "<leader>gs", function() gs.stage_hunk() end, "Stage hunk")
        map("n", "<leader>gr", function() gs.reset_hunk() end, "Reset hunk")
        map("n", "<leader>gS", function() gs.stage_buffer() end, "Stage buffer")
        map("n", "<leader>gR", function() gs.reset_buffer() end, "Reset buffer")
        map("n", "<leader>gb", function() gs.blame_line() end, "Blame line")
        map("n", "<leader>gB", function() gs.toggle_current_line_blame() end, "Toggle line blame")
      end,
    },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Git diff" },
      { "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "Close diff" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Branch history" },
    },
    opts = {},
  },
}

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<leader>tt", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Toggle terminal (vertical)" },
    { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Toggle terminal (float)" },
  },
  opts = {
    direction = "vertical",
    size = function(term)
      if term.direction == "vertical" then
        return vim.o.columns * 0.4
      elseif term.direction == "horizontal" then
        return 15
      end
    end,
    float_opts = {
      border = "curved",
    },
    on_open = function(term)
      -- jk to exit terminal mode
      vim.keymap.set("t", "jk", [[<C-\><C-n>]], { buffer = term.bufnr, desc = "Exit terminal mode" })
    end,
  },
}

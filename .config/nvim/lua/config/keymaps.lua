local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Close buffer
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer" })

-- Better indenting (stay in visual mode)
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move lines in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Keep cursor position when joining lines
map("n", "J", "mzJ`z")

-- Diagnostic navigation
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Diagnostic float" })

-- NOTE: Standard Ctrl keys that are NOT captured by zellij and work fine:
--   Ctrl-w  (window management)
--   Ctrl-d / Ctrl-u  (half-page scroll)
--   Ctrl-f / Ctrl-b  ... wait, Ctrl-b IS captured by zellij
--   Ctrl-r  (redo)
--   Ctrl-v  (visual block)
--   Ctrl-]  (tag jump)
--   Ctrl-^  (alternate buffer)
--
-- Zellij captures: Ctrl-g, h, o, b, s, t, p, n, q
-- All custom keymaps use <leader>, g-prefix, or bracket-prefix to avoid conflicts.

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Resize splits on window resize
autocmd("VimResized", {
  group = augroup("resize-splits", { clear = true }),
  command = "tabdo wincmd =",
})

-- Close certain filetypes with q
autocmd("FileType", {
  group = augroup("close-with-q", { clear = true }),
  pattern = { "help", "man", "qf", "checkhealth", "diffview*" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

-- Auto-reload files changed outside vim
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("auto-reload", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

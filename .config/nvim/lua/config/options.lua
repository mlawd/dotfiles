-- Leader key (must be set before lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation (2 spaces)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Appearance
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.wrap = false

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Undo persistence
vim.opt.undofile = true

-- Scroll
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Auto-reload files changed outside vim (needed for opencode.nvim)
vim.opt.autoread = true

-- Misc
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.mouse = "a"
vim.opt.swapfile = false
vim.opt.backup = false

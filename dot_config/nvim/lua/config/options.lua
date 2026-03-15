-- Options (mirrors your .ideavimrc preferences)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.clipboard = "unnamedplus"

opt.showmode = true
opt.showcmd = true
opt.visualbell = true

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

opt.splitright = true
opt.splitbelow = true

opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true

opt.undofile = true
opt.swapfile = false

-- note: vim.g.mapleader is set in init.lua, before lazy.nvim loads

vim.opt.number = true -- enable line numbers
vim.wo.relativenumber = true -- enable relative line numbers
vim.opt.mouse = 'a' -- enable mouse support in all modes
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.smartcase = true -- respect case with uppercase letters
vim.opt.hlsearch = true -- highlight all search matches
vim.opt.incsearch = true -- incremental search
vim.opt.wrap = true -- wrap long lines
vim.opt.breakindent = true -- wrap long lines at indentation
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.tabstop = 2 -- set tab width to 2 spaces
vim.opt.shiftwidth = 2 -- set indentation level to 2 spaces
vim.opt.smartindent = true
vim.opt.clipboard = 'unnamedplus' -- access system clipboard
vim.opt.so = 7 -- set scroll offset to 7
vim.opt.showmode = false -- disable mode display
vim.opt.iskeyword:append '-' -- include - in keywords
vim.opt.foldmethod = 'marker'
vim.opt.cursorline = true -- highlight current line
vim.opt.splitright = true -- open new split to the right
vim.opt.splitbelow = true -- open new split below
vim.opt.signcolumn = 'yes' -- always show sign column
vim.opt.winborder = 'single' -- default border for floating windows

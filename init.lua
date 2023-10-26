vim.opt.number = true               -- enable line numbers
vim.opt.mouse = 'a'                 -- enable mouse support in all modes
vim.opt.ignorecase = true           -- ignore case in search patterns
vim.opt.smartcase = true            -- respect case with uppercase letters
vim.opt.hlsearch = true             -- highlight all search matches
vim.opt.incsearch = true            -- incremental search
vim.opt.wrap = true                 -- wrap long lines
vim.opt.breakindent = true          -- wrap long lines at indentation
vim.opt.tabstop = 2                 -- set tab width to 2 spaces
vim.opt.shiftwidth = 2              -- set indentation level to 2 spaces
vim.opt.expandtab = true            -- convert tabs to spaces
vim.opt.clipboard = 'unnamedplus'   -- access system clipboard
vim.opt.so = 7                      -- set scroll offset to 7
vim.opt.showmode = false            -- disable mode display

vim.g.mapleader = ','               -- set the leader key to ','


-- key map to clear search highlighting
vim.keymap.set('n', '<Leader><Space>', ':nohlsearch<CR>')


-- bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- setup plugins
require("lazy").setup({
	'morhetz/gruvbox',
	{ 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
	'sheerun/vim-polyglot',
})


-- setup color theme
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.g.gruvbox_contrast_dark = 'hard'
vim.cmd.colorscheme('gruvbox')


-- lualine configuration
require('lualine').setup {
	options = {
		theme = 'gruvbox'
	},
	tabline = {
		lualine_a = { 'buffers' },
		lualine_z = { 'tabs' },
	},
}

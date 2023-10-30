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

-- key map to manage buffers
vim.keymap.set('n', '<Leader>n', ':bnext<CR>')
vim.keymap.set('n', '<Leader>p', ':bprevious<CR>')
vim.keymap.set('n', '<Leader>d', ':bdelete<CR>')


-- bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- setup plugins
require('lazy').setup({
	'morhetz/gruvbox',
	{ 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
	'sheerun/vim-polyglot',
	'williamboman/mason.nvim',
	'williamboman/mason-lspconfig.nvim',
	'neovim/nvim-lspconfig',
	'mfussenegger/nvim-lint',
	'mhartington/formatter.nvim',
	{ 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
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

-- diagnostic keybindings
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- setup lsp
require('mason').setup()
require('mason-lspconfig').setup({
	ensure_installed = { 'lua_ls', 'hls' }
})

local on_attach = function(_, _)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
end

local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup {
	on_attach = on_attach,
	settings = {
		Lua = { diagnostics = { globals = { 'vim' } } }
	}
}
lspconfig.hls.setup {
	on_attach = on_attach
}

-- setup treesitter
require('nvim-treesitter.configs').setup({
  ensure_installed = { 'haskell', 'javascript', 'c', 'lua', 'vim', 'vimdoc', 'query' },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

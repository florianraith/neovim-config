-- Options {{{
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
vim.g.mapleader = ' ' -- set the leader key
-- }}}

-- Keymaps {{{
-- key map to clear search highlighting
vim.keymap.set('n', '<leader><space>', ':nohlsearch<cr>')

-- diagnostic keybindings
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- key map to manage buffers
vim.keymap.set('n', '<leader>bn', ':bnext<cr>')
vim.keymap.set('n', '<leader>bp', ':bprevious<cr>')
vim.keymap.set('n', '<leader>bd', ':bdelete<cr>')

-- remap j,k to gj,gk
vim.keymap.set('n', '<C-j>', 'gj')
vim.keymap.set('n', '<C-k>', 'gk')

-- key map for formatting
vim.keymap.set('n', '<leader>p', function()
  require('conform').format { timeout_ms = 3000 }
end)
vim.keymap.set('n', '<leader>rp', ':silent %!prettier --stdin-filepath %<cr>')

-- key map fro neo tree
vim.keymap.set('n', '<leader>l', function()
  require('neo-tree.command').execute { toggle = true, dir = vim.uv.cwd() }
end)

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Map refactorings
local function inline_var()
  vim.cmd 'normal! gd'
  vim.cmd 'Refactor inline_var'
end

vim.keymap.set('n', '<leader>xi', inline_var, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>xr', function()
  require('refactoring').select_refactor()
end, { noremap = true, silent = true })

-- key maps during lsp session
local on_attach = function(_, bufnr)
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>rr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
end
-- }}}

-- LazyVIM {{{
-- bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- setup plugins
require('lazy').setup {
  -- colorschemes
  { 'folke/tokyonight.nvim', lazy = false, priority = 1000, opts = {} },
  { 'rose-pine/neovim', priority = 1000, name = 'rose-pine' },
  { 'sainnhe/gruvbox-material', priority = 1000 },
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  { 'rebelot/kanagawa.nvim', priority = 1000 },
  { 'ellisonleao/gruvbox.nvim', priority = 1000, config = true },
  { 'marko-cerovac/material.nvim' },

  -- functionality
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  { 'nvim-telescope/telescope.nvim', tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'benfowler/telescope-luasnip.nvim' },
  { 'onsails/lspkind.nvim' },
  { 'numToStr/Comment.nvim', opts = {}, lazy = false },
  { 'tpope/vim-surround' },
  { 'windwp/nvim-ts-autotag' },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
  },
  { 'zbirenbaum/copilot.lua' },
  { 'AndreM222/copilot-lualine' },
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('refactoring').setup()
    end,
  },

  -- lsp
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },
  { 'neovim/nvim-lspconfig' },
  { 'tikhomirov/vim-glsl' },
  { 'stevearc/conform.nvim' },

  -- autocompletion
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-nvim-lua' },
  { 'L3MON4D3/LuaSnip' },
}
-- }}}

vim.cmd [[colorscheme rose-pine]]

-- Clears the background color so that the terminal background shows through
local function clear_background()
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'none' })
end

clear_background()
vim.api.nvim_create_augroup('TransparentBg', {})
vim.api.nvim_create_autocmd('ColorScheme', {
  group = 'TransparentBg',
  callback = clear_background,
})

vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
--- }}}

-- Setup comment {{{
require('Comment').setup()
-- }}}

-- Setup ts autotag {{{
require('nvim-ts-autotag').setup()
-- }}}

-- Setup Lualine {{{
require('lualine').setup {
  sections = {
    lualine_b = { 'branch', 'diff' },
    lualine_c = { { 'filename', path = 1 }, 'diagnostics' },
    lualine_x = {
      {
        'copilot',
        symbols = {
          status = {
            icons = {
              enabled = '',
              sleep = '',
              disabled = '',
              warning = '',
              unknown = '',
            },
          },
        },
      },
      'tabs',
    },
    lualine_y = { 'filetype' },
    lualine_z = { 'location' },
  },
}
-- }}}

-- Setup lsp {{{
local lsp = require 'lsp-zero'
lsp.on_attach(on_attach)

lsp.set_sign_icons {
  error = '󰅚', -- x000f015a
  warn = '󰀪', -- x000f002a
  info = '󰋽', -- x000f02fd
  hint = '󰌶', -- x000f0336
}

lsp.setup()

vim.lsp.config('lua_ls', lsp.nvim_lua_ls())

require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = {
    'lua_ls',
    'clangd',
  },
}
-- }}}

-- Setup formatting {{{
local function contains(array, value)
  for _, v in ipairs(array) do
    if v == value then
      return true
    end
  end
  return false
end

local priorities = {
  biome = 1000,
}

-- inject the formatters installed through mason into conform
local packages = require('mason-registry').get_installed_packages()
local formatters_by_ft = {}

for _, package in ipairs(packages) do
  if contains(package.spec.categories, 'Formatter') then
    for _, lang in ipairs(package.spec.languages) do
      local lang_lower = string.lower(lang)
      if not formatters_by_ft[lang_lower] then
        formatters_by_ft[lang_lower] = {}
      end

      table.insert(formatters_by_ft[lang_lower], package.name)
    end
  end
end

-- sort each list by our priorities (default 0), highest first
for ft, list in pairs(formatters_by_ft) do
  table.sort(list, function(a, b)
    local pa = priorities[a] or 0
    local pb = priorities[b] or 0
    return pa > pb
  end)

  -- if there's more than one, stop on the first
  if #list > 1 then
    list.stop_after_first = true
  end
end

-- for _, formatters in pairs(formatters_by_ft) do
--   if #formatters > 1 then
--     formatters['stop_after_first'] = true
--   end
-- end

require('conform').setup {
  formatters_by_ft = formatters_by_ft,
}
-- }}}

-- Setup telescope {{{

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>ff', builtin.git_files, {})
vim.keymap.set('n', '<leader>fa', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>;', function()
  builtin.buffers { initial_mode = 'normal', sort_mru = true, sort_lastused = true }
end, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

local previewers = require 'telescope.previewers'
local previewers_utils = require 'telescope.previewers.utils'

local max_size = 10000
local truncate_large_files = function(filepath, bufnr, opts)
  opts = opts or {}

  filepath = vim.fn.expand(filepath)
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat then
      return
    end
    if stat.size > max_size then
      local cmd = { 'head', '-c', max_size, filepath }
      previewers_utils.job_maker(cmd, bufnr, opts)
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end

local actions = require 'telescope.actions'

require('telescope').setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '-L',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
    buffer_previewer_maker = truncate_large_files,
    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
  },
}

require('telescope').load_extension 'luasnip'

--- }}}

-- Setup autocompletion {{{
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
  },
  preselect = 'item',
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = {
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if luasnip.expandable() then
          luasnip.expand()
        else
          cmp.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true }
        end
      else
        fallback()
      end
    end),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_locally_jumpable() then
        if luasnip.locally_jumpable(1) then
          luasnip.jump(1)
        else
          luasnip.expand()
        end
      elseif cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      elseif cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  formatting = {
    format = require('lspkind').cmp_format {
      menu = {
        buffer = '[Buffer]',
        nvim_lsp = '[LSP]',
        luasnip = '[LuaSnip]',
        nvim_lua = '[Lua]',
        latex_symbols = '[Latex]',
      },
    },
  },
}

luasnip.config.set_config {
  region_check_events = 'InsertEnter',
  delete_check_events = 'TextChanged,InsertLeave',
}

require('luasnip.loaders.from_vscode').lazy_load { paths = '~/.config/nvim/snippets' }
require('luasnip.loaders.from_lua').load { paths = '~/.config/nvim/snippets' }

-- }}}

-- Setup treesitter {{{
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'haskell',
    'javascript',
    'typescript',
    'c',
    'cpp',
    'lua',
    'vim',
    'vimdoc',
    'query',
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
}

local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.blade = {
  install_info = {
    url = 'https://github.com/EmranMR/tree-sitter-blade',
    files = { 'src/parser.c' },
    branch = 'main',
  },
  filetype = 'blade',
}
-- }}}

-- Setup copilot {{{

require('copilot').setup {
  filetypes = {
    gitcommit = true,
    markdown = true,
    yaml = true,
  },
  suggestion = {
    auto_trigger = true,
  },
}

-- }}}

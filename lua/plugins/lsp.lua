return {
  -- mason.setup runs on load rather than from lsp-zero's config, because
  -- conform.nvim also reads the mason registry and either one may load first.
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonLog', 'MasonUpdate' },
    opts = {},
  },
  { 'williamboman/mason-lspconfig.nvim', lazy = true },
  { 'neovim/nvim-lspconfig', lazy = true },

  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      local lsp = require 'lsp-zero'

      -- key maps during lsp session
      lsp.on_attach(function(_, bufnr)
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>rr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      end)

      lsp.set_sign_icons {
        error = '󰅚', -- x000f015a
        warn = '󰀪', -- x000f002a
        info = '󰋽', -- x000f02fd
        hint = '󰌶', -- x000f0336
      }

      lsp.setup()

      vim.lsp.config('lua_ls', lsp.nvim_lua_ls())

      require('mason-lspconfig').setup {
        ensure_installed = {
          'lua_ls',
          'clangd',
        },
      }
    end,
  },
}

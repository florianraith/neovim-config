-- Native LSP setup (Neovim 0.11+). mason installs the servers,
-- mason-lspconfig enables each installed one via vim.lsp.enable(), and
-- nvim-lspconfig supplies the per-server defaults in its lsp/ directory.
return {
  -- mason.setup runs on load rather than from a consumer's config, because
  -- conform.nvim also reads the mason registry and either may load first.
  {
    'mason-org/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonLog', 'MasonUpdate' },
    opts = {},
  },

  { 'mason-org/mason-lspconfig.nvim', lazy = true },

  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
    },
    config = function()
      vim.diagnostic.config {
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚', -- x000f015a
            [vim.diagnostic.severity.WARN] = '󰀪', -- x000f002a
            [vim.diagnostic.severity.INFO] = '󰋽', -- x000f02fd
            [vim.diagnostic.severity.HINT] = '󰌶', -- x000f0336
          },
        },
      }

      -- key maps during lsp session
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspAttach', { clear = true }),
        callback = function(event)
          local opts = { buffer = event.buf, remap = false }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>rr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        end,
      })

      -- Teach lua_ls about the Neovim runtime. Merged on top of the defaults
      -- nvim-lspconfig ships in lsp/lua_ls.lua.
      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, 'lua/?.lua')
      table.insert(runtime_path, 'lua/?/init.lua')

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            telemetry = { enable = false },
            runtime = {
              version = 'LuaJIT',
              path = runtime_path,
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.fn.expand '$VIMRUNTIME/lua',
                vim.fn.stdpath 'config' .. '/lua',
              },
            },
          },
        },
      })

      -- must come after vim.lsp.config: this is what calls vim.lsp.enable()
      require('mason-lspconfig').setup {
        ensure_installed = {
          'lua_ls',
          'clangd',
        },
      }
    end,
  },
}

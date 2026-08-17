return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'L3MON4D3/LuaSnip',
    'benfowler/telescope-luasnip.nvim',
  },
  config = function()
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
      vim.uv.fs_stat(filepath, function(_, stat)
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
  end,
}

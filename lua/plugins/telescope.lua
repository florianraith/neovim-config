return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  cmd = 'Telescope',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'L3MON4D3/LuaSnip',
    'benfowler/telescope-luasnip.nvim',
  },
  keys = {
    {
      '<leader>ff',
      function()
        require('telescope.builtin').git_files()
      end,
      desc = 'Find git files',
    },
    {
      '<leader>fa',
      function()
        require('telescope.builtin').find_files()
      end,
      desc = 'Find all files',
    },
    {
      '<leader>fg',
      function()
        require('telescope.builtin').live_grep()
      end,
      desc = 'Live grep',
    },
    {
      '<leader>fb',
      function()
        require('telescope.builtin').buffers()
      end,
      desc = 'Find buffers',
    },
    {
      '<leader>;',
      function()
        require('telescope.builtin').buffers { initial_mode = 'normal', sort_mru = true, sort_lastused = true }
      end,
      desc = 'Recent buffers',
    },
    {
      '<leader>fh',
      function()
        require('telescope.builtin').help_tags()
      end,
      desc = 'Find help tags',
    },
  },
  config = function()
    local previewers = require 'telescope.previewers'
    local previewers_utils = require 'telescope.previewers.utils'

    -- telescope 0.1.8 calls nvim-treesitter.parsers.ft_to_lang(), gone on the main branch
    previewers_utils.ts_highlighter = function(bufnr, ft)
      local lang = vim.treesitter.language.get_lang(ft)
      if not lang then
        return false
      end
      return (pcall(vim.treesitter.start, bufnr, lang))
    end

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

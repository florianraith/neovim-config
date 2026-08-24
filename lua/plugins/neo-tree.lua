return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  cmd = 'Neotree',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  opts = {
    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
    },
    window = {
      mappings = {
        ['<leader>z'] = function(state)
          local node = state.tree:get_node()
          local from = state.current_position or 'left'
          local cmd = require 'neo-tree.command'
          cmd.execute { action = 'close', position = from }
          cmd.execute {
            action = 'focus',
            position = from == 'current' and 'left' or 'current',
            dir = vim.uv.cwd(),
            reveal_file = node and node.type == 'file' and node.path or nil,
          }
        end,
        ['Y'] = function(state)
          local node = state.tree:get_node()
          local root = vim.fs.root(node.path, '.git')
          local path
          if root then
            path = vim.fs.relpath(root, node.path) or node.path
          else
            path = vim.fn.fnamemodify(node.path, ':.')
          end
          vim.fn.setreg('+', path)
          vim.notify('Copied: ' .. path)
        end,
        ['gy'] = function(state)
          local node = state.tree:get_node()
          vim.fn.setreg('+', node.path)
          vim.notify('Copied: ' .. node.path)
        end,
      },
    },
  },
  keys = {
    {
      '<leader>l',
      function()
        if vim.b.neo_tree_position == 'current' then
          require('neo-tree.command').execute { action = 'close', position = 'current' }
        else
          require('neo-tree.command').execute { toggle = true, reveal = true, dir = vim.uv.cwd() }
        end
      end,
      desc = 'Toggle neo-tree',
    },
  },
}

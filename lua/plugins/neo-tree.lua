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
        require('neo-tree.command').execute { toggle = true, reveal = true, dir = vim.uv.cwd() }
      end,
      desc = 'Toggle neo-tree',
    },
  },
}

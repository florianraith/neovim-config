return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'AndreM222/copilot-lualine',
  },
  opts = {
    sections = {
      lualine_b = { 'branch', 'diff' },
      lualine_c = { { 'filename', path = 1 }, 'diagnostics' },
      lualine_x = {
        {
          'copilot',
          symbols = {
            status = {
              icons = {
                enabled = '',
                sleep = '',
                disabled = '',
                warning = '',
                unknown = '',
              },
            },
          },
        },
        'tabs',
      },
      lualine_y = { 'filetype' },
      lualine_z = { 'location' },
    },
  },
}

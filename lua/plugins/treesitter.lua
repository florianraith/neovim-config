return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  lazy = false,
  config = function()
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

    -- Blade support. The matching highlight/injection queries live in
    -- after/queries/blade/, which nvim picks up via runtimepath, not from here.
    local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
    parser_config.blade = {
      install_info = {
        url = 'https://github.com/EmranMR/tree-sitter-blade',
        files = { 'src/parser.c' },
        branch = 'main',
      },
      filetype = 'blade',
    }
  end,
}

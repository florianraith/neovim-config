-- Loaded on demand by nvim-cmp and telescope, which both declare it a dependency.
return {
  'L3MON4D3/LuaSnip',
  lazy = true,
  config = function()
    local luasnip = require 'luasnip'

    luasnip.config.set_config {
      region_check_events = 'InsertEnter',
      delete_check_events = 'TextChanged,InsertLeave',
    }

    require('luasnip.loaders.from_vscode').lazy_load { paths = '~/.config/nvim/snippets' }
    require('luasnip.loaders.from_lua').load { paths = '~/.config/nvim/snippets' }
  end,
}

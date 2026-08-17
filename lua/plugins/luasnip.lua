return {
  'L3MON4D3/LuaSnip',
  lazy = false,
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

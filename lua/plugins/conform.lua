-- Derives conform's formatters_by_ft from whatever mason has installed, rather
-- than maintaining the mapping by hand. Depends on mason.nvim being loaded so
-- the registry is readable; because conform itself is lazy, that registry scan
-- is deferred to the first format or write instead of running at startup.
return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  cmd = 'ConformInfo',
  dependencies = { 'williamboman/mason.nvim' },
  keys = {
    {
      '<leader>p',
      function()
        require('conform').format { timeout_ms = 3000 }
      end,
      desc = 'Format buffer',
    },
  },
  config = function()
    local function contains(array, value)
      for _, v in ipairs(array) do
        if v == value then
          return true
        end
      end
      return false
    end

    local priorities = {
      biome = 1000,
    }

    -- inject the formatters installed through mason into conform
    local packages = require('mason-registry').get_installed_packages()
    local formatters_by_ft = {}

    for _, package in ipairs(packages) do
      if contains(package.spec.categories, 'Formatter') then
        for _, lang in ipairs(package.spec.languages) do
          local lang_lower = string.lower(lang)
          if not formatters_by_ft[lang_lower] then
            formatters_by_ft[lang_lower] = {}
          end

          table.insert(formatters_by_ft[lang_lower], package.name)
        end
      end
    end

    -- sort each list by our priorities (default 0), highest first
    for _, list in pairs(formatters_by_ft) do
      table.sort(list, function(a, b)
        local pa = priorities[a] or 0
        local pb = priorities[b] or 0
        return pa > pb
      end)

      -- if there's more than one, stop on the first
      if #list > 1 then
        list.stop_after_first = true
      end
    end

    require('conform').setup {
      formatters_by_ft = formatters_by_ft,
    }
  end,
}

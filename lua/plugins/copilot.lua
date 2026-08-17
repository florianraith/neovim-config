return {
  'zbirenbaum/copilot.lua',
  event = 'InsertEnter',
  opts = {
    filetypes = {
      gitcommit = true,
      markdown = true,
      yaml = true,
    },
    suggestion = {
      auto_trigger = true,
    },
  },
}

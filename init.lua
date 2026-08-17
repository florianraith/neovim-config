-- The leader key must be set before lazy.nvim loads. Plugin specs resolve
-- `<leader>` at spec-evaluation time, so setting it later silently binds
-- plugin keymaps against the wrong prefix.
vim.g.mapleader = ' '

require 'core.options'
require 'core.keymaps'

-- bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- every file in lua/plugins/ returns a spec
require('lazy').setup {
  spec = { { import = 'plugins' } },
}

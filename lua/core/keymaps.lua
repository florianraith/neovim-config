-- Global keymaps. Plugin-specific keymaps live with their plugin in lua/plugins/.

-- key map to clear search highlighting
vim.keymap.set('n', '<leader><space>', ':nohlsearch<cr>')

-- diagnostic keybindings
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end)
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- key map to manage buffers
vim.keymap.set('n', '<leader>bn', ':bnext<cr>')
vim.keymap.set('n', '<leader>bp', ':bprevious<cr>')
vim.keymap.set('n', '<leader>bd', ':bdelete<cr>')

-- remap j,k to gj,gk
vim.keymap.set('n', '<C-j>', 'gj')
vim.keymap.set('n', '<C-k>', 'gk')

-- format through prettier directly, bypassing conform
vim.keymap.set('n', '<leader>rp', ':silent %!prettier --stdin-filepath %<cr>')

-- fix grammar with Claude
vim.keymap.set('n', '<leader>gg', function()
  require('user.claude_grammar').fix_buffer()
end, { desc = 'Fix grammar with Claude' })

-- make
vim.keymap.set('n', '<leader>m', function()
  vim.cmd 'botright 15split'
  vim.cmd 'terminal make'
  vim.cmd 'startinsert'
end, { desc = 'Run make in terminal' })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

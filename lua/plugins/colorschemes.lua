-- rose-pine is the active theme and loads eagerly; the rest are installed but
-- only pulled in when `:colorscheme <name>` asks for them.
return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd [[colorscheme rose-pine]]

      -- Clears the background color so that the terminal background shows through
      local function clear_background()
        vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'none' })
      end

      clear_background()
      vim.api.nvim_create_augroup('TransparentBg', {})
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = 'TransparentBg',
        callback = clear_background,
      })

      vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
    end,
  },

  { 'folke/tokyonight.nvim', lazy = true, opts = {} },
  { 'sainnhe/gruvbox-material', lazy = true },
  { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
  { 'rebelot/kanagawa.nvim', lazy = true },
  { 'ellisonleao/gruvbox.nvim', lazy = true, config = true },
  { 'marko-cerovac/material.nvim', lazy = true },
}

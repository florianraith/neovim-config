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

      -- Drop only the background so the terminal shows through; nvim_set_hl
      -- replaces rather than merges, so the rest is carried over by hand.
      -- Floats are transparent too; winborder is what separates them.
      local function clear_background()
        for _, group in ipairs { 'Normal', 'NormalNC', 'EndOfBuffer', 'SignColumn', 'NormalFloat', 'FloatBorder' } do
          local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
          hl.bg, hl.ctermbg = nil, nil
          vim.api.nvim_set_hl(0, group, hl)
        end
      end

      clear_background()
      vim.api.nvim_create_augroup('TransparentBg', {})
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = 'TransparentBg',
        callback = clear_background,
      })
    end,
  },

  { 'folke/tokyonight.nvim', lazy = true, opts = {} },
  { 'sainnhe/gruvbox-material', lazy = true },
  { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
  { 'rebelot/kanagawa.nvim', lazy = true },
  { 'ellisonleao/gruvbox.nvim', lazy = true, config = true },
  { 'marko-cerovac/material.nvim', lazy = true },
}

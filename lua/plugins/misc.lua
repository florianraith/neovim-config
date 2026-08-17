-- Plugins with no configuration worth a file of their own.
return {
  { 'tpope/vim-surround', event = 'VeryLazy' },
  { 'numToStr/Comment.nvim', event = 'VeryLazy', opts = {} },
  { 'windwp/nvim-ts-autotag', event = 'InsertEnter', opts = {} },
  { 'tikhomirov/vim-glsl', ft = 'glsl' },
}

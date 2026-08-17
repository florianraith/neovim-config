-- The main branch is required on Neovim 0.12; master is frozen and crashes on
-- injections. It enables nothing by default and cannot be lazy-loaded.
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local ts = require 'nvim-treesitter'

    ts.setup()

    vim.treesitter.language.register('json', 'jsonc')

    -- no auto_install on this branch; already-installed parsers are skipped
    ts.install {
      'asm',
      'bash',
      'bibtex',
      'blade',
      'c',
      'cpp',
      'css',
      'csv',
      'dockerfile',
      'git_config',
      'git_rebase',
      'gitcommit',
      'gitignore',
      'glimmer',
      'glsl',
      'go',
      'haskell',
      'html',
      'ini',
      'java',
      'javascript',
      'json',
      'kotlin',
      'latex',
      'lua',
      'luadoc',
      'make',
      'markdown',
      'markdown_inline',
      'nginx',
      'perl',
      'php',
      'printf',
      'python',
      'query',
      'requirements',
      'robots_txt',
      'rust',
      'sql',
      'ssh_config',
      'svelte',
      'toml',
      'tsv',
      'typescript',
      'vim',
      'vimdoc',
      'vue',
      'xml',
      'yaml',
    }

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('UserTreesitter', { clear = true }),
      callback = function()
        if not pcall(vim.treesitter.start) then
          return
        end

        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}

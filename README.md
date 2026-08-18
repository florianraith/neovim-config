# Neovim configuration

Personal Neovim config. Requires **Neovim 0.12+**.

Leader key is `<Space>`.

## Layout

```
init.lua                  leader, options/keymaps, lazy.nvim bootstrap
lua/core/options.lua      editor options
lua/core/keymaps.lua      global keymaps, yank highlight autocmd
lua/user/claude_grammar.lua   the <leader>gg grammar fix job
lua/plugins/*.lua         one spec file per plugin or domain
snippets/                 LuaSnip snippets (vscode and lua format)
stylua.toml               formatting rules for this config
lazy-lock.json            pinned plugin revisions
```

Every file in `lua/plugins/` returns a lazy.nvim spec and is picked up automatically by `{ import = 'plugins' }`.

## Keybindings

### General

| Key | Action |
| --- | --- |
| `<leader><space>` | Clear search highlighting |
| `<C-j>` / `<C-k>` | Move down/up by display line (`gj` / `gk`), useful with wrapped lines |
| `<leader>bn` / `<leader>bp` | Next / previous buffer |
| `<leader>bd` | Delete buffer |
| `<leader>m` | Run `make` in a 15 line terminal split |
| `<leader>gg` | Fix grammar of the whole buffer with Claude, result appended below |

### Diagnostics

| Key | Action |
| --- | --- |
| `<leader>e` | Show diagnostic in a float |
| `[d` / `]d` | Jump to previous / next diagnostic, opening a float |
| `<leader>q` | Send buffer diagnostics to the location list |

### LSP (active only while a server is attached)

| Key | Action |
| --- | --- |
| `gd` | Go to definition |
| `gi` | Go to implementation |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>rr` | List references |
| `<leader>ca` | Code action |

### Find (Telescope)

| Key | Action |
| --- | --- |
| `<leader>ff` | Git files |
| `<leader>fa` | All files, hidden files included |
| `<leader>fg` | Live grep |
| `<leader>fb` | Open buffers |
| `<leader>;` | Recent buffers, opens in normal mode sorted by most recent use |
| `<leader>fh` | Help tags |
| `<C-j>` / `<C-k>` | Next / previous entry while typing in a picker |

### Files and formatting

| Key | Action |
| --- | --- |
| `<leader>l` | Toggle neo-tree at the current working directory, revealing the current buffer's file |
| `Y` (in neo-tree) | Copy the hovered file or folder path relative to the git root, falling back to the current working directory when there is no git root |
| `gy` (in neo-tree) | Copy the absolute path of the hovered file or folder |
| `<leader>p` | Format buffer with conform (3 second timeout) |
| `<leader>rp` | Format buffer by piping it through `prettier`, bypassing conform |

### Laravel

| Key | Action |
| --- | --- |
| `<leader>ih` | Generate the IDE helper files for the Laravel project the current buffer belongs to |

### Completion and snippets (insert mode)

| Key | Action |
| --- | --- |
| `<Tab>` | Jump to next snippet placeholder, expand a snippet, otherwise next completion item |
| `<S-Tab>` | Jump to previous snippet placeholder, otherwise previous completion item |
| `<CR>` | Expand snippet if expandable, otherwise confirm the selected completion |

### Provided by Neovim itself

`gc` and `gcc` (comment toggle) are builtin since 0.10, so no commenting plugin is installed. Blockwise `gb` and `gbc` are **not** available.

## Plugins

### Plugin manager

| Plugin | Why |
| --- | --- |
| `folke/lazy.nvim` | Plugin manager. Bootstrapped by `init.lua`, then loads every spec in `lua/plugins/`. |

### Colorschemes

| Plugin | Why |
| --- | --- |
| `rose-pine/neovim` | The active theme. Loads eagerly with `priority = 1000` so it wins the load order. |
| `folke/tokyonight.nvim`, `sainnhe/gruvbox-material`, `catppuccin/nvim`, `rebelot/kanagawa.nvim`, `ellisonleao/gruvbox.nvim`, `marko-cerovac/material.nvim` | Alternatives kept installed but lazy. They load only when `:colorscheme <name>` asks for them. |

### LSP

| Plugin | Why |
| --- | --- |
| `mason-org/mason.nvim` | Installs language servers, formatters and linters into `~/.local/share/nvim/mason`. |
| `mason-org/mason-lspconfig.nvim` | Bridges mason to `vim.lsp.enable()`, so every installed server is enabled automatically. |
| `neovim/nvim-lspconfig` | Supplies per server defaults (commands, root markers, settings) as `lsp/*.lua` files. Carries this config's LSP setup. |

There is no lsp-zero. Server enabling, keymaps, sign icons and per server settings all use the native Neovim 0.11+ API.

### Completion and snippets

| Plugin | Why |
| --- | --- |
| `hrsh7th/nvim-cmp` | Completion engine. |
| `hrsh7th/cmp-nvim-lsp` | LSP completion source. |
| `hrsh7th/cmp-nvim-lua` | Neovim Lua API completion source. |
| `saadparwaiz1/cmp_luasnip` | Snippet completion source. |
| `onsails/lspkind.nvim` | Icons and source labels in the completion menu. |
| `L3MON4D3/LuaSnip` | Snippet engine, loads the `snippets/` directory. |

### Syntax and formatting

| Plugin | Why |
| --- | --- |
| `nvim-treesitter/nvim-treesitter` (branch `main`) | Parser installation and queries. Drives highlighting and indentation. |
| `windwp/nvim-ts-autotag` | Auto closes and renames HTML/JSX tags. |
| `stevearc/conform.nvim` | Formatting, wired to whatever mason has installed. |

### Navigation

| Plugin | Why |
| --- | --- |
| `nvim-telescope/telescope.nvim` | Fuzzy finder for files, grep, buffers and help. |
| `benfowler/telescope-luasnip.nvim` | Browse available snippets through Telescope. |
| `nvim-neo-tree/neo-tree.nvim` | File tree sidebar. |
| `nvim-lua/plenary.nvim`, `MunifTanjim/nui.nvim` | Library dependencies of the two above. |

### UI

| Plugin | Why |
| --- | --- |
| `nvim-lualine/lualine.nvim` | Statusline. |
| `AndreM222/copilot-lualine` | Copilot status indicator in the statusline. |
| `nvim-tree/nvim-web-devicons` | File type icons. |

### Editing and AI

| Plugin | Why |
| --- | --- |
| `tpope/vim-surround` | Add, change and delete surrounding quotes, brackets and tags. |
| `zbirenbaum/copilot.lua` | GitHub Copilot inline suggestions. |

## Configuration notes

### Loading strategy

Everything is lazy loaded except the colorscheme and treesitter, both of which have to be present for the first rendered frame. Triggers are:

| Trigger | Plugins |
| --- | --- |
| `VeryLazy` | lualine, vim-surround |
| `InsertEnter` | nvim-cmp, copilot.lua, nvim-ts-autotag |
| `BufReadPre` / `BufNewFile` | nvim-lspconfig and the mason stack |
| `BufWritePre` | conform.nvim |
| Keys or commands | telescope, neo-tree |
| Dependency only | LuaSnip, plenary, nui, devicons, cmp sources |

### treesitter

Pinned to the `main` branch. The `master` branch is frozen and its query directives rely on a compatibility shim that Neovim 0.12 removed, which crashes highlighting on any file containing injections (PHP, Markdown, Telescope previews).

Consequences of that branch:

* It cannot be lazy loaded, so it is `lazy = false`.
* It enables nothing by itself. Highlighting and indentation are turned on per buffer by a `FileType` autocmd, guarded by `pcall` so filetypes without a parser fall back to regex syntax and the builtin indent script.
* There is no `auto_install`, so the parser list is declared explicitly. Parsers already present are skipped without touching the network.
* `jsonc` has no parser on this branch, so it is registered to the `json` one.

Parsers install to `~/.local/share/nvim/site/parser`.

### conform

`formatters_by_ft` is not maintained by hand. It is derived at load time by scanning the mason registry for packages in the `Formatter` category and mapping them onto the languages they declare. Where a filetype ends up with several formatters, `stop_after_first` is set and `biome` is given priority over the others.

Because conform itself is lazy, that registry scan is deferred to the first write or format rather than running at startup.

### LSP

`mason.setup` runs from mason's own spec rather than from a consumer's config, because conform also reads the mason registry and either plugin may load first.

`ensure_installed` covers only `lua_ls` and `clangd`. Everything else currently installed was added by hand through `:Mason` and is not reproducible from this config.

`lua_ls` gets the Neovim runtime path and library injected so `vim` resolves and config files are understood. Those settings merge on top of the defaults nvim-lspconfig ships.

Diagnostic sign icons are set through `vim.diagnostic.config`.

`laravel_lsp` is the odd one out. It is [laravel/lsp](https://github.com/laravel/lsp), installed with `composer global require laravel/lsp` rather than through mason, so `automatic_enable` never sees it and it is enabled by hand. The whole block is wrapped in an `executable()` check, so the config stays inert on a machine that does not have it. Its `root_dir` only resolves when an `artisan` file is found, which keeps it from starting on PHP projects that are not Laravel applications. The command is looked up on `PATH` first and falls back to Composer's global bin directory, which is not on `PATH` by default.

It is framework aware rather than a general PHP server: completion, hover and go to definition for route names, view names, config keys and translation keys, with no diagnostics or rename. Run it alongside a PHP language server such as `phpactor`, not instead of one.

Note that `laravel-ls` in mason and `laravel_ls` in nvim-lspconfig are a different project ([laravel-ls/laravel-ls](https://github.com/laravel-ls/laravel-ls)) and are not used here.

### Telescope

* Previews of files over 10 KB are truncated with `head`, keeping the preview responsive on large files.
* `find_files` includes hidden files.
* ripgrep runs with `-L` so symlinks are followed, and `--smart-case`.

### neo-tree

`filesystem.follow_current_file` is enabled, so while the tree is open it jumps to the file of whatever buffer you switch to and expands the parent folders on the way. With `leave_dirs_open = false`, folders that were auto expanded for a previous file collapse again, so the tree does not accumulate open directories as you move around.

The `<leader>l` toggle passes `reveal = true`, which does the same thing for the moment the tree opens (`follow_current_file` only reacts to buffer changes while it is already open). A buffer outside the current working directory makes neo-tree ask whether to change the root.

### Colorscheme transparency

The background is stripped from `Normal`, `NormalNC`, `EndOfBuffer`, `SignColumn`, `NormalFloat` and `FloatBorder` so the terminal background shows through.

Two details matter here:

1. `nvim_set_hl` **replaces** a highlight rather than merging into it, so each group's existing attributes are read first and only the background is removed. Setting `{ bg = 'none' }` directly would also discard the foreground, which makes body text fall back to the terminal's colour and turns the `~` end of buffer markers bright in themes that deliberately hide them.
2. Because floats are transparent too, `winborder = 'single'` is what separates a float from the content behind it. This matters most for one line floats such as diagnostics.

The whole thing runs from a `ColorScheme` autocmd, so it survives switching themes and works for all seven installed colorschemes rather than hardcoding rose-pine values.

### Completion behaviour

`<Tab>` and `<S-Tab>` are snippet aware first and completion aware second, so jumping between placeholders takes precedence over cycling the completion menu. `<CR>` expands a snippet when one is expandable, otherwise it confirms the highlighted item. `noinsert` is set so nothing is written into the buffer until confirmed.

### Snippets

Loaded from `snippets/` by LuaSnip, in both VSCode JSON and Lua format. Expand with `<Tab>`, browse everything available with `:Telescope luasnip`.

#### `lorem<N>`

A custom snippet, available in every filetype, that generates `N` words of lorem ipsum. Inspired by how PhpStorm does it. Type the trigger with the count baked in, then press `<Tab>`:

| Type | Result |
| --- | --- |
| `lorem3` | `Lorem ipsum dolor.` |
| `lorem10` | `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.` |
| `lorem25` | `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis.` |

The count is a regex capture (`lorem(%d+)`), so any number works. Words are taken in order from a fixed six sentence corpus, which repeats if you ask for more words than it holds, and a full stop is appended when the result does not already end in one.

#### JavaScript and TypeScript

`snippets/javascript.json` provides a VSCode style set (`log`, `class`, `iface`, `for`, `forof`, `trycatch`, `prop`, `get`, `set` and others), registered for `javascript`, `javascriptreact`, `typescript`, `typescriptreact`, `vue` and `svelte`.

### Laravel IDE helper generation

`<leader>ih` regenerates the [barryvdh/laravel-ide-helper](https://github.com/barryvdh/laravel-ide-helper) files for the Laravel project the current buffer belongs to, streaming progress into a floating window so failures are visible while they happen.

It runs three commands in sequence:

| Step | Command | Writes |
| --- | --- | --- |
| generate | `ide-helper:generate` | `_ide_helper.php` |
| models | `ide-helper:models --nowrite` | `_ide_helper_models.php` |
| meta | `ide-helper:meta` | `.phpstorm.meta.php` |

`--nowrite` is the important flag. Without it, `ide-helper:models` writes `@property` docblocks directly into the model classes; with it, everything lands in `_ide_helper_models.php` and no existing PHP file is touched. Every step also gets `--no-interaction`, because a prompt would hang a job that has no terminal attached.

Three things happen before any command runs:

1. The project root is located with `vim.fs.root(0, 'artisan')`. Without one, the keymap warns and does nothing.
2. The runner is chosen. If `vendor/bin/sail` exists the commands go through Sail, otherwise through `php` directly. This matters because `ide-helper:models` needs a working database connection, and a containerised database is usually only reachable from inside the container. The chosen runner is printed in the window.
3. `vendor/barryvdh/laravel-ide-helper` is checked. If the package is missing, the window shows the install command matching the chosen runner, and `y` copies it to the clipboard.

`q` or `<Esc>` closes the window. The generated files are derived artifacts and belong in the project's `.gitignore`.

Why this is worth having: a general PHP language server cannot know an Eloquent model's columns, because they come from the database schema. `_ide_helper_models.php` supplies them as `@property` docblocks, which is what makes `$model->column` complete. It only helps where the variable's type is actually known, so a value coming from something typed loosely (`auth()->user()`, for instance) stays uncompletable until the call site is annotated.

### Claude grammar fix

`<leader>gg` writes the buffer to a temp file, pipes it through `claude -p` with a Haiku model, and appends the corrected text below the original rather than replacing it. A spinner renders as virtual text below the last line while the job runs. Requires the `claude` CLI on `PATH`.

## Maintenance

| Command | Purpose |
| --- | --- |
| `:Lazy sync` | Install, update and clean plugins, then update `lazy-lock.json` |
| `:Lazy clean` | Remove plugins no longer in any spec |
| `:Mason` | Install or remove language servers and formatters |
| `:TSUpdate` | Update treesitter parsers |
| `:ConformInfo` | Show which formatters resolve for the current buffer |
| `:checkhealth` | Diagnose a broken setup |

External tools expected on `PATH`: `git`, `rg`, `curl`, `tar`, a C compiler, `tree-sitter` (0.26.1+, installed via a package manager rather than npm), and `claude` for the grammar keymap.

Not managed by this config, and needed only for PHP work:

| Tool | Install | Used by |
| --- | --- | --- |
| `laravel-lsp` | `composer global require laravel/lsp` | The `laravel_lsp` language server |
| `barryvdh/laravel-ide-helper` | `composer require --dev barryvdh/laravel-ide-helper`, per project | `<leader>ih` |

Composer's global bin directory (`~/.composer/vendor/bin`) does not need to be on `PATH`; the config falls back to it.

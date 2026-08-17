local M = {}

-- --nowrite keeps ide-helper:models out of the model classes themselves; it
-- writes _ide_helper_models.php instead.
local STEPS = {
  { name = 'generate', args = { 'ide-helper:generate' }, output = '_ide_helper.php' },
  { name = 'models', args = { 'ide-helper:models', '--nowrite' }, output = '_ide_helper_models.php' },
  { name = 'meta', args = { 'ide-helper:meta' }, output = '.phpstorm.meta.php' },
}

local PACKAGE = 'barryvdh/laravel-ide-helper'

local function open_window()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = 'idehelper'

  local width = math.min(100, math.floor(vim.o.columns * 0.8))
  local height = math.min(24, math.floor(vim.o.lines * 0.6))
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    style = 'minimal',
    title = ' ide-helper ',
    title_pos = 'center',
  })
  vim.wo[win].wrap = true

  for _, key in ipairs { 'q', '<Esc>' } do
    vim.keymap.set('n', key, function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end, { buffer = buf, nowait = true })
  end

  return { buf = buf, win = win }
end

local function append(state, lines)
  if not vim.api.nvim_buf_is_valid(state.buf) then
    return
  end
  vim.bo[state.buf].modifiable = true
  -- a fresh scratch buffer already holds one empty line
  local current = vim.api.nvim_buf_get_lines(state.buf, 0, -1, false)
  local from = (#current == 1 and current[1] == '') and 0 or -1
  vim.api.nvim_buf_set_lines(state.buf, from, -1, false, lines)
  vim.bo[state.buf].modifiable = false

  if vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_set_cursor(state.win, { vim.api.nvim_buf_line_count(state.buf), 0 })
  end
end

-- jobstart hands back a list whose last entry is a partial line, and progress
-- bars arrive as carriage returns.
local function append_output(state, data)
  if not data then
    return
  end
  local lines = {}
  for _, chunk in ipairs(data) do
    for piece in tostring(chunk):gmatch '[^\r]+' do
      if piece:match '%S' then
        table.insert(lines, '  ' .. piece)
      end
    end
  end
  if #lines > 0 then
    append(state, lines)
  end
end

local function finish(state)
  append(state, { '', ('─'):rep(40) })

  local failed = {}
  for _, step in ipairs(STEPS) do
    local result = state.results[step.name]
    local path = state.root .. '/' .. step.output
    local stat = vim.uv.fs_stat(path)
    local mark = result == 0 and '✓' or '✗'
    if result ~= 0 then
      table.insert(failed, step.name)
    end
    append(state, {
      string.format('%s %-9s %s%s', mark, step.name, step.output, stat and string.format('  (%.1f KB)', stat.size / 1024) or '  (not written)'),
    })
  end

  if #failed > 0 then
    append(state, { '', 'Failed: ' .. table.concat(failed, ', ') .. '. Output above.' })
  end
  append(state, { '', 'q / <Esc> to close' })
end

local function run_step(state, index)
  local step = STEPS[index]
  if not step then
    finish(state)
    return
  end

  append(state, { '', '── ' .. step.name .. ' ' .. ('─'):rep(36 - #step.name) })

  local cmd = vim.list_extend(vim.deepcopy(state.runner), step.args)
  table.insert(cmd, '--no-interaction')

  vim.fn.jobstart(cmd, {
    cwd = state.root,
    on_stdout = vim.schedule_wrap(function(_, data)
      append_output(state, data)
    end),
    on_stderr = vim.schedule_wrap(function(_, data)
      append_output(state, data)
    end),
    on_exit = vim.schedule_wrap(function(_, code)
      state.results[step.name] = code
      if code ~= 0 then
        append(state, { string.format('  exited with %d', code) })
      end
      run_step(state, index + 1)
    end),
  })
end

local function missing_package(state, install_cmd)
  append(state, {
    PACKAGE .. ' is not installed in this project.',
    '',
    'Install it as a dev dependency:',
    '',
    '  ' .. install_cmd,
    '',
    'Press y to copy that command, q / <Esc> to close.',
  })

  vim.keymap.set('n', 'y', function()
    vim.fn.setreg('+', install_cmd)
    vim.notify('Copied: ' .. install_cmd)
  end, { buffer = state.buf, nowait = true })
end

function M.generate()
  local root = vim.fs.root(0, 'artisan')
  if not root then
    vim.notify('No artisan file found; not a Laravel project.', vim.log.levels.WARN)
    return
  end

  local sail = root .. '/vendor/bin/sail'
  local use_sail = vim.fn.executable(sail) == 1
  local runner = use_sail and { sail, 'artisan' } or { 'php', 'artisan' }

  local state = open_window()
  state.root = root
  state.runner = runner
  state.results = {}

  append(state, {
    'project: ' .. vim.fn.fnamemodify(root, ':~'),
    'runner:  ' .. (use_sail and 'sail artisan' or 'php artisan'),
  })

  if not vim.uv.fs_stat(root .. '/vendor/' .. PACKAGE) then
    local install = (use_sail and './vendor/bin/sail composer' or 'composer') .. ' require --dev ' .. PACKAGE
    append(state, { '' })
    missing_package(state, install)
    return
  end

  run_step(state, 1)
end

return M

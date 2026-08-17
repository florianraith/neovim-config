-- Pipes the current buffer through `claude -p` to fix grammar, then appends the
-- corrected text below the original. Shows a spinner as virtual text while the
-- job runs. Bound to <leader>gg in lua/core/keymaps.lua.

local M = {}

local PROMPT = 'Fix the grammar of the following text. Keep any informal or colloquial style intact (e.g. wanna, gonna). Output only the corrected text, nothing else.'

function M.fix_buffer()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  -- spinner setup (virtual text below last line)
  local ns = vim.api.nvim_create_namespace 'claude_spinner'
  local spinner_frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
  local frame = 0
  local last_line = vim.api.nvim_buf_line_count(buf) - 1
  local timer = vim.uv.new_timer()

  timer:start(
    0,
    100,
    vim.schedule_wrap(function()
      frame = (frame % #spinner_frames) + 1
      vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
      vim.api.nvim_buf_set_extmark(buf, ns, last_line, 0, {
        virt_lines = { { { spinner_frames[frame] .. ' Claude is fixing grammar...', 'Comment' } } },
      })
    end)
  )

  -- write buffer content to a temp file for stdin piping
  local tmpfile = vim.fn.tempname()
  vim.fn.writefile(lines, tmpfile)

  local cmd = 'cat ' .. vim.fn.shellescape(tmpfile) .. ' | claude -p --model claude-haiku-4-5 ' .. vim.fn.shellescape(PROMPT)

  -- run claude async, piping temp file via stdin
  local result = {}
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        result = data
      end
    end,
    on_exit = vim.schedule_wrap(function(_, exit_code)
      timer:stop()
      timer:close()
      vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
      vim.fn.delete(tmpfile)

      if exit_code ~= 0 then
        vim.notify('Claude grammar fix failed (exit ' .. exit_code .. ')', vim.log.levels.ERROR)
        return
      end

      -- remove trailing empty strings from job output
      while #result > 0 and result[#result] == '' do
        table.remove(result)
      end

      if #result > 0 then
        local count = vim.api.nvim_buf_line_count(buf)
        vim.api.nvim_buf_set_lines(buf, count, count, false, { '' })
        vim.api.nvim_buf_set_lines(buf, count + 1, count + 1, false, result)
      end
    end),
  })
end

return M

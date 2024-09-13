local ls = require 'luasnip'
local s = ls.snippet
local f = ls.function_node

-- Snippet to generate lorem ipsum text with a specified amount of words.
-- (Inspired by how PhpStorm does it)

local function generate_lorem(words)
  local lorem_text = {
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
    'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
    'Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.',
  }

  local full_text = table.concat(lorem_text, ' ')
  local word_list = {}
  for word in full_text:gmatch '%S+' do
    table.insert(word_list, word)
  end

  while #word_list < tonumber(words) do
    for word in full_text:gmatch '%S+' do
      table.insert(word_list, word)
    end
  end

  local result = table.concat(vim.list_slice(word_list, 1, tonumber(words)), ' ')

  if not result:match '%.%s*$' then
    result = result .. '.'
  end

  return result
end

return {
  s({ trig = 'lorem(%d+)', regTrig = true }, {
    f(function(_, snip)
      local word_count = snip.captures[1]
      return generate_lorem(word_count)
    end, {}),
  }),
}

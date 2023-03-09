return {
  'phaazon/hop.nvim',
  enabled = true,
  event = "User AstroFile",
  branch = 'v2',
  opts = { keys = 'ntesirhdoa' },
  init = function ()
    local hop = require('hop')
    local directions = require('hop.hint').HintDirection

    vim.keymap.set('', 'f', function()
      hop.hint_char2({ direction = directions.AFTER_CURSOR,  current_line_only = true })
    end, {remap=true})

    vim.keymap.set('', 'F', function()
      hop.hint_char2({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    end, {remap=true})

    vim.keymap.set('', 's', function()
      hop.hint_char2({ direction = directions.BOTH,          current_line_only = false })
    end, {remap=true})

    --[[ vim.keymap.set('', 'S', function()
      hop.hint_char2({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    end, {remap=true}) ]]

    vim.keymap.set('', 't', function()
      hop.hint_char2({ direction = directions.AFTER_CURSOR,  current_line_only = true, hint_offset = -1 })
    end, {remap=true})

    vim.keymap.set('', 'T', function()
      hop.hint_char2({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 2 })
    end, {remap=true})

  end
}

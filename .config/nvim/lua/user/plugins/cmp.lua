local cmp = require "cmp"
return {
  window = {
    completion = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
  },
  mapping = {
    ["<Right>"] = cmp.mapping.confirm { select = false },
  },
}

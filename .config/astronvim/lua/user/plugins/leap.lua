return {
  'ggandor/leap.nvim',
  enabled = false,
  event = "User AstroFile",
  init = function()
    require('leap').add_default_mappings()
  end,
  opts = { keys = 'ntesirhdoa' }
}

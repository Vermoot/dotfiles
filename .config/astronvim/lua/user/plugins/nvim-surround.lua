return {
  'kylechui/nvim-surround',
  event = "User AstroFile",
  config = function()
    require("nvim-surround").setup()
  end
}

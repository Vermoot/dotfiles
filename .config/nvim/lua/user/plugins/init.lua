-- Guide {{{
-- You can disable default plugins as follows:
-- ["goolord/alpha-nvim"] = { disable = true },

-- You can also add new plugins here as well:
-- Add plugins, the packer syntax without the "use"
-- { "andweeb/presence.nvim" },
-- {
--   "ray-x/lsp_signature.nvim",
--   event = "BufRead",
--   config = function()
--     require("lsp_signature").setup()
--   end,
-- },

-- We also support a key value style plugin definition similar to NvChad:
-- ["ray-x/lsp_signature.nvim"] = {
--   event = "BufRead",
--   config = function()
--     require("lsp_signature").setup()
--   end,
-- },
-- }}}

return {
  { 'ellisonleao/gruvbox.nvim', config = function() require("user.plugins.gruvbox") end },
  { "echasnovski/mini.nvim",    config = function() require("mini.align").setup() end },
  { "karb94/neoscroll.nvim",    config = function() require("user.plugins.neoscroll") end },
  { "junegunn/vim-easy-align" },
  -- { "hrsh7th/cmp-cmdline",      config = function() require("user.plugins.cmp-cmdline") end},
}

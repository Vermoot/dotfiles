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
  { 'ellisonleao/gruvbox.nvim',  config = function() require("user.plugins.gruvbox") end },
  -- { "karb94/neoscroll.nvim",  config = function() require("user.plugins.neoscroll") end },
  { 'echasnovski/mini.nvim',     branch = "stable" },
  { 'echasnovski/mini.animate',  config = function() require('user.plugins.mini-animate') end,  branch = "stable" },
  { "kylechui/nvim-surround",    config = function() require("user.plugins.nvim-surround") end, tag = "*" },
  { "junegunn/vim-easy-align" },
  { "jackMort/ChatGPT.nvim",     config = function() require("user.plugins.chatgpt") end,
                                 requires = {
                                   "MunifTanjim/nui.nvim",
                                   "nvim-lua/plenary.nvim",
                                   "nvim-telescope/telescope.nvim"
                                 }
  },
  { "aduros/ai.vim"},
  { "Exafunction/codeium.vim" },
}

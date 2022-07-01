-- Packer doing its thing {{{
local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}
--}}}

return packer.startup(function(use)
  use {
    "wbthomason/packer.nvim",
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    'psliwka/vim-smoothie',
    'unblevable/quick-scope',
    'ap/vim-css-color',
    'glacambre/firenvim',
    'tpope/vim-surround',
    'wellle/targets.vim',
    'jiangmiao/auto-pairs',
    'justinmk/vim-sneak',
    'alvan/vim-closetag',
    'tpope/vim-repeat',
    'liuchengxu/vim-which-key',
    'preservim/nerdcommenter',
    'iamcco/markdown-preview.nvim',
    'kyazdani42/nvim-web-devicons',
    'akinsho/bufferline.nvim',
    'moll/vim-bbye',
    { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'},
    'p00f/nvim-ts-rainbow',
    'junegunn/vim-easy-align',
    'eraserhd/parinfer-rust',
    'nvim-telescope/telescope.nvim',
    'kevinhwang91/rnvimr',

    -- cmp
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'saadparwaiz1/cmp_luasnip',
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',

    -- LSP
    'neovim/nvim-lspconfig',
    'williamboman/nvim-lsp-installer',

    -- Language support
    'sheerun/vim-polyglot',
    'tridactyl/vim-tridactyl',
    'elkowar/yuck.vim',
    'fladson/vim-kitty',
    'baskerville/vim-sxhkdrc',

    -- Color Schemes
    'joshdick/onedark.vim',
    'ellisonleao/gruvbox.nvim',
    'doums/darcula',
    'vim-airline/vim-airline',
    'vim-airline/vim-airline-themes',
    'rainglow/vim',
    'drewtempelmeyer/palenight.vim',
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

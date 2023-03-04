return {
  "nvim-treesitter",
  dependencies = {
    "andymass/vim-matchup",
    "HiPhish/nvim-ts-rainbow2"
  },
  opts = {
    ensure_installed = { "lua", "python" },
    matchup = { enable = true },
    rainbow = { enable = true },
  },
}

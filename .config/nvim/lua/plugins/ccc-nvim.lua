return {
  { "NvChad/nvim-colorizer.lua", enabled = false },
  {
    "uga-rosa/ccc.nvim",
    event = { "User AstroFile", "InsertEnter" },
    cmd = { "CccPick", "CccConvert", "CccHighlighterEnable", "CccHighlighterDisable", "CccHighlighterToggle" },
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>uC"] = { "<Cmd>CccHighlighterToggle<CR>", desc = "Toggle colorizer" },
              ["<Leader>zc"] = { "<Cmd>CccConvert<CR>", desc = "Convert color" },
              ["<Leader>zp"] = { "<Cmd>CccPick<CR>", desc = "Pick Color" },
            },
          },
        },
      },
    },

    opts = function(_, opts)
      local ccc = require "ccc"
      return vim.tbl_deep_extend("force", opts, {
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
        mappings = {
          -- ["<Left>"]  =  ccc.mapping.decrease1,
          -- ["<Right>"] =  ccc.mapping.increase1,
          -- ["<"]       =  ccc.mapping.decrease10,
          -- [">"]       =  ccc.mapping.increase10,
          -- ["<Esc>"]   =  ccc.mapping.quit,
        },
      })
    end,

    config = function(_, opts)
      require("ccc").setup(opts)
      if opts.highlighter and opts.highlighter.auto_enable then vim.cmd.CccHighlighterEnable() end
    end,
  },
}

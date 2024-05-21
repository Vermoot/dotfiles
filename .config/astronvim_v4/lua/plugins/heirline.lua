return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    local status = require("astroui.status")
    opts.statusline = {
      hl = { fg = "fg", bg = "bg" },
      status.component.mode(),
      status.component.git_branch(),
      status.component.file_info(),
      status.component.diagnostics(),
      status.component.fill(),
      status.component.lsp(),
      status.component.treesitter(),
      status.component.nav(),
      -- status.component.filetype(),
      -- status.component.line_col(),
      -- status.component.percent(),
      -- status.component.scrollbar(),
    }
    return opts
  end,
}

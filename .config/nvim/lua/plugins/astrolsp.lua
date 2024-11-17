---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@param opts AstroLSPOpts
  opts = function(plugin, opts)
    -- enable servers that you already have installed without mason
    opts.servers = opts.servers or {}
    table.insert(opts.servers, "kos")

    opts.config = require("astrocore").extend_tbl(opts.config or {}, {

      kos = {
        cmd = {
          "kls",
          "--stdio",
        },
        filetypes = { "kerboscript" },
        root_dir = require("lspconfig.util").root_pattern ".git",
      },
    })

    opts.formatting = require("astrocore").extend_tbl(opts.formatting or {}, {
      format_on_save = {
        enabled = false,
      },
    })
  end,
}

return {
      after = "nvim-cmp",
      config = function()
        local cmp = require "cmp"
        local select_next = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end
        local select_prev = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end
        local mappings = cmp.mapping.preset.cmdline {
          ["<C-j>"] = { c = select_next },
          ["<C-k>"] = { c = select_prev },
          ["<Down>"] = { c = select_next },
          ["<Up>"] = { c = select_prev },
        }
        cmp.setup.cmdline(":", {
          mapping = mappings,
          sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
        })
        cmp.setup.cmdline({ "/", "?" }, {
          mapping = mappings,
          sources = { { name = "buffer" } },
        })
      end,
    }

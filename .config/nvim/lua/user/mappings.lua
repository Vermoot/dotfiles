return {

  -- NORMAL MODE {{{
    n = {
      -- Buffers
      ["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
      ["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
      ["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
      ["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },

      ["<M-CR>"]  = { "<cmd>BufferLineCyclePrev<cr>" },
      ["<M-Tab>"] = { "<cmd>BufferLineCycleNext<cr>" },

      -- Movement across windows
      ["<C-m>"] = { "<C-w>W", desc = "Move focus to the previous window" },
      ["<C-i>"] = { "<C-w>w", desc = "Move focus to the next window" },

      -- Smooth PageUp/Down
      -- ["<PageUp>"]   = { "<C-b>" },
      -- ["<PageDown>"] = { "<C-f>" },
      ["<PageUp>"]   = false,
      ["<PageDown>"] = false,

      -- Move across wrapped lines
      ["j"]      = { "gj" },
      ["k"]      = { "gk" },
      ["<Up>"]   = { "g<Up>" },
      ["<Down>"] = { "g<Down>" },

      -- Easy-Align
      ["ga"] = { "<Plug>(EasyAlign)", desc = "Easy Align" },

      -- Better increment/decrement
      ["-"] = { "<c-x>", desc = "Descrement number" },
      ["+"] = { "<c-a>", desc = "Increment number" },

      -- Suppress yanking on operations
      ["d"] = {"\"_d"},
      ["x"] = {"\"_x"},
      ["c"] = {"\"_c"},

    },
  -- END NORMAL MODE }}}

  -- INSERT MODE {{{
    i = {
      -- Move across buffers
      ["<M-CR>"]  = { "<cmd>BufferLineCyclePrev<cr>" },
      ["<M-Tab>"] = { "<cmd>BufferLineCycleNext<cr>" },
    },
  -- END INSERT MODE }}}

  -- VISUAL MODE {{{
    v = {
      -- Move across buffers
      ["<M-CR>"]  = { "<cmd>BufferLineCyclePrev<cr>" },
      ["<M-Tab>"] = { "<cmd>BufferLineCycleNext<cr>" },

      -- Easy-Align
      ["ga"] = { "<Plug>(EasyAlign)", desc = "Easy Align" },

      -- Suppress yanking on operations
      d = "\"_d",
      c = "\"_c",

    },
  -- END VISUAL MODE }}}

  -- COMMAND MODE {{{
    c = {
      ["<PageUp>"]   = {"<Up>"},
      ["<PageDown>"] = {"<Down>"},
    },


  -- END COMMAND MODE }}}

  -- TERMINAL MODE {{{
    t = {
      ["<C-m>"] = { "<C-w>W" },
      ["<C-i>"] = { "<C-w>w" },
      -- setting a mapping to false will disable it
      -- ["<esc>"] = false,
    },
  -- END TERMINAL MODE }}}

}
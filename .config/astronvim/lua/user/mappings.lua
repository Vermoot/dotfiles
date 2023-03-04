-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)

local function meh (key)
  return "<C-M-S-" .. key .. ">"
end

return {

  -- NORMAL MODE {{{
    n = {
      ["<leader><leader"] = { "", desc = "More..." },
      -- Buffers
      [meh("m")] = { function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end, desc = "Next buffer" },
      [meh("i")] = { function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end, desc = "Previous buffer"},

      -- Movement across windows
      ["<C-m>"] = { "<C-w>W", desc = "Move focus to the previous window" },
      ["<C-i>"] = { "<C-w>w", desc = "Move focus to the next window" },
      ["<CR>"] = { "" },
      -- ["<Tab>"] = {""},

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
      -- ["d"] = {"\"_d"},
      -- ["x"] = {"\"_x"},
      -- ["c"] = {"\"_c"},

      -- ChatGPT
      ["<leader><leader>cc"] = {"<cmd>ChatGPT<cr>", desc = "ChatGPT" },
      ["<leader><leader>ce"] = {"<cmd>ChatGPTEditWithInstruction<cr>", desc = "ChatGPT Edit" },
    },
  -- END NORMAL MODE }}}

  -- INSERT MODE {{{
    i = {
      -- Move across buffers
      [meh("m")] = { "<cmd>BufferLineCyclePrev<cr>" },
      [meh("i")] = { "<cmd>BufferLineCycleNext<cr>" },
      ["<C-i>"] = {"<C-i>"},
      -- ["<CR>"] = {"<CR>"},
    },
  -- END INSERT MODE }}}

  -- VISUAL MODE {{{
    v = {
      -- Move across buffers
      [meh("m")]  = { "<cmd>BufferLineCyclePrev<cr>" },
      [meh("i")] = { "<cmd>BufferLineCycleNext<cr>" },

      -- Easy-Align
      ["ga"] = { "<Plug>(EasyAlign)", desc = "Easy Align" },

      -- Suppress yanking on operations
      -- ["d"] = { "\"_d" },
      -- ["p"] = {"\"_dP"},
      -- ["c"] = { "\"_c" },

      -- ChatGPT
      ["<leader><leader>ce"] = {"<cmd>ChatGPTEditWithInstruction<cr>", desc = "ChatGPT Edit" },

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
      ["<CR>"] = { "<CR>" },
      ["<Tab>"] = { "<Tab>" },
      ["<C-m>"] = { "<C-w>W" },
      ["<C-i>"] = { "<C-w>w" },
      -- setting a mapping to false will disable it
      -- ["<esc>"] = false,
    },
  -- END TERMINAL MODE }}}

}

local function meh(key) return "<C-M-S-" .. key .. ">" end

return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        -- first key is the mode
        n = {
          ["<leader><leader>"] = { name = "More..." },

          -- Buffers
          [meh "i"] = {
            function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
            desc = "Next buffer",
          },
          [meh "m"] = {
            function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
            desc = "Previous buffer",
          },

          -- Movement across windows
          ["<C-m>"] = { "<C-w>W", desc = "Move focus to the previous window" },
          ["<C-i>"] = { "<C-w>w", desc = "Move focus to the next window" },
          ["<CR>"] = { "" },
          ["<Tab>"] = { "<Tab>" },

          -- Move across wrapped lines
          ["j"] = { "gj" },
          ["k"] = { "gk" },
          ["<Up>"] = { "g<Up>" },
          ["<Down>"] = { "g<Down>" },

          -- Easy-Align
          ["ga"] = { "<Plug>(EasyAlign)", desc = "Easy Align" },

          -- Better increment/decrement
          -- ["-"] = { "<c-x>", desc = "Descrement number" },
          -- ["+"] = { "<c-a>", desc = "Increment number" },

          -- ChatGPT
          ["<leader><leader>c"] = { name = "ChatGPT" },
          ["<leader><leader>cc"] = { "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
          ["<leader><leader>ce"] = { "<cmd>ChatGPTEditWithInstruction<CR>", desc = "ChatGPT Edit" },

          -- Arduino
          ["<leader>a"] = { name = "Arduino" },
          ["<leader>aa"] = { "<cmd>ArduinoAttach<CR>", desc = "Arduino Attach" },
          ["<leader>av"] = { "<cmd>ArduinoVerify<CR>", desc = "Arduino Verify" },
          ["<leader>ai"] = { "<cmd>ArduinoInfo<CR>", desc = "Arduino Info" },
          ["<leader>aI"] = { "<cmd>ArduinoGetInfo<CR>", desc = "Arduino Get Info" },
          ["<leader>au"] = { "<cmd>ArduinoUpload<CR>", desc = "Arduino Upload" },
          ["<leader>aU"] = { "<cmd>ArduinoUploadAndSerial<CR>", desc = "Arduino Upload and Serial" },
          ["<leader>as"] = { "<cmd>ArduinoSerial<CR>", desc = "Arduino Serial" },
          ["<leader>ab"] = { "<cmd>ArduinoChooseBoard<CR>", desc = "Arduino Choose Board" },
          ["<leader>ap"] = { "<cmd>ArduinoChoosePort<CR>", desc = "Arduino Choose Port" },
          ["<leader>aP"] = { "<cmd>ArduinoChooseProgrammer<CR>", desc = "Arduino Choose Programmer" },

          -- Suppress yanking on operations
          ["d"] = { '"_d' },
          ["x"] = { '"_x' },
          ["c"] = { '"_c' },

          -- Mental health
          ["q:"] = ":",
        },
        i = {
          -- Move across buffers
          [meh "i"] = {
            function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
            desc = "Next buffer",
          },
          [meh "m"] = {
            function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
            desc = "Previous buffer",
          },
          ["<Tab>"] = { "<Tab>" },
          ["<C-i>"] = { "<C-i>" },
          -- ["<CR>"] = {"<CR>"},
          ["<Up>"] = { "<C-o>g<Up>" },
          ["<Down>"] = { "<C-o>g<Down>" },
        },
        v = {
          ["<leader><leader>"] = { name = "More..." },
          -- Move across buffers
          [meh("i")] = { function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end, desc = "Next buffer" },
          [meh("m")] = { function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end, desc = "Previous buffer"},

          -- Easy-Align
          ["ga"] = { "<Plug>(EasyAlign)", desc = "Easy Align" },

          -- ChatGPT
          ["<leader><leader>c"] = { name = "ChatGPT" },
          ["<leader><leader>cc"] = {"<cmd>ChatGPT<cr>", desc = "ChatGPT" },
          ["<leader><leader>ce"] = {"<cmd>ChatGPTEditWithInstruction<cr>", desc = "ChatGPT Edit" },

          -- Suppress yanking on operations
          ["d"] = {"\"_d"},
          ["p"] = {"P"},
          ["c"] = {"\"_c"},

          -- Better increment/decrement
          -- ["-"] = { "<c-x>gv", desc = "Descrement number" },
          -- ["+"] = { "<c-a>gv", desc = "Increment number" },
          -- ["g-"] = { "g<c-x>gv", desc = "Descrement number sequentially" },
          -- ["g+"] = { "g<c-a>gv", desc = "Increment number sequentially" },

        },
        c = {
          ["<PageUp>"]   = {"<Up>"},
          ["<PageDown>"] = {"<Down>"},
        },
        t = {
          ["<CR>"] = { "<CR>" },
          ["<Tab>"] = { "<Tab>" },
          ["<C-m>"] = { "<C-w>W" },
          ["<C-i>"] = { "<C-w>w" },
          -- setting a mapping to false will disable it
          -- ["<esc>"] = false,
        },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      mappings = {
        n = {},
      },
    },
  },
}

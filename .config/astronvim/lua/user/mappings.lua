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

            ["<leader><leader>"] = { name = "More..." },

            -- Buffers
            [meh("i")] = { function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end, desc = "Next buffer" },
            [meh("m")] = { function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end, desc = "Previous buffer"},

            -- Movement across windows
            ["<C-m>"] = { "<C-w>W", desc = "Move focus to the previous window" },
            ["<C-i>"] = { "<C-w>w", desc = "Move focus to the next window" },
            ["<CR>"]  = { "" },
            ["<Tab>"] = {"<Tab>"},

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

            -- ChatGPT
            ["<leader><leader>c"]  = { name = "ChatGPT" },
            ["<leader><leader>cc"] = {"<cmd>ChatGPT<cr>", desc = "ChatGPT" },
            ["<leader><leader>ce"] = {"<cmd>ChatGPTEditWithInstruction<cr>", desc = "ChatGPT Edit" },

            -- Suppress yanking on operations
            ["d"] = {"\"_d"},
            ["x"] = {"\"_x"},
            ["c"] = {"\"_c"},

            -- Mental health
            ["q:"] = ":",
        },
        -- END NORMAL MODE }}}

        -- INSERT MODE {{{
            i = {
                -- Move across buffers
                [meh("i")] = { function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end, desc = "Next buffer" },
                [meh("m")] = { function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end, desc = "Previous buffer"},
                ["<Tab>"] = {"<Tab>"},
                ["<C-i>"] = {"<C-i>"},
                -- ["<CR>"] = {"<CR>"},
            },
            -- END INSERT MODE }}}

            -- VISUAL MODE {{{
                v = {
                    ["<leader><leader>"] = { name = "More..." },
                    -- Move across buffers
                    [meh("i")] = { function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end, desc = "Next buffer" },
                    [meh("m")] = { function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end, desc = "Previous buffer"},

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

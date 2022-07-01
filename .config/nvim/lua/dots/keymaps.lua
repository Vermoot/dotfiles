local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Move across wrapped lines
keymap("n", "j", "gj", opts)
keymap("n", "k", "gk", opts)
keymap("n", "<Up>", "g<Up>", opts)
keymap("n", "<Down>", "g<Down>", opts)

keymap("n", "<leader>w", ":w<cr>", opts)
keymap("n", "<leader>q", ":q<cr>", opts)
keymap("n", "<leader>Q", ":q!<cr>", opts)
keymap("n", "<leader>x", ":x<cr>", opts)

keymap("n", "d", '"_d', opts)
keymap("v", "d", '"_d', opts)
keymap("n", "x", '"_x', opts)
keymap("n", "c", '"_c', opts)

keymap("n", "<M-CR>", ':BufferLineCyclePrev<cr>', opts)
keymap("n", "<M-Tab>", ':BufferLineCycleNext<cr>', opts)



-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

--[[
   [ -- Move text up and down
   [ keymap("v", "<A-n>", ":m .+1<CR>==", opts)
   [ keymap("v", "<A-e>", ":m .-2<CR>==", opts)
   [ keymap("v", "p", '"_dP', opts)
   [
   [ -- Visual Block --
   [ -- Move text up and down
   [ keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
   [ keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
   [ keymap("x", "<A-n>", ":move '>+1<CR>gv-gv", opts)
   [ keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)
   ]]

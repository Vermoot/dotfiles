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

-- Leader stuff
keymap("n", "<leader>w", ":w<cr>", opts)
keymap("n", "<leader>q", ":q<cr>", {desc = "Quit nvim"})
keymap("n", "<leader>Q", ":q!<cr>", opts)
keymap("n", "<leader>x", ":x<cr>", opts)

keymap("n", "d", '"_d', opts)
keymap("v", "d", '"_d', opts)
keymap("n", "x", '"_x', opts)
keymap("n", "c", '"_c', opts)

keymap("n", "<M-CR>", ':BufferLineCyclePrev<cr>', opts)
keymap("n", "<M-Tab>", ':BufferLineCycleNext<cr>', opts)

-- LSP stuff
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD',        vim.lsp.buf.declaration,             bufopts)
  vim.keymap.set('n', 'gd',        vim.lsp.buf.definition,              bufopts)
  vim.keymap.set('n', 'K',         vim.lsp.buf.hover,                   bufopts)
  vim.keymap.set('n', 'gi',        vim.lsp.buf.implementation,          bufopts)
  vim.keymap.set('n', '<C-k>',     vim.lsp.buf.signature_help,          bufopts)
  vim.keymap.set('n', '<leader>D',  vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,          bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,     bufopts)
  vim.keymap.set('n', 'gr',        vim.lsp.buf.references,      bufopts)
  vim.keymap.set('n', '<leader>f',  vim.lsp.buf.formatting,      bufopts)
end

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
-- keymap("n", "<M-n>", ":m .+1<CR>==", opts)
-- keymap("n", "<M-e>", ":m .-2<CR>==", opts)
-- keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-n>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

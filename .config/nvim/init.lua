local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

-- Plugins {{{

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

require 'packer'.startup(function(use)
	use { 'psliwka/vim-smoothie' }
	use { 'unblevable/quick-scope' }
	use { 'ap/vim-css-color' }
	use { 'glacambre/firenvim' }
	use { 'tpope/vim-surround' }
	use { 'wellle/targets.vim' }
	use { 'jiangmiao/auto-pairs' }
	use { 'justinmk/vim-sneak' }
	use { 'kien/rainbow_parentheses.vim' }
	use { 'alvan/vim-closetag' }
	use { 'tpope/vim-repeat' }
	use { 'liuchengxu/vim-which-key' }
	use { 'preservim/nerdcommenter' }
	use { 'iamcco/markdown-preview.nvim' }
	use { 'kyazdani42/nvim-web-devicons' }
	use { 'akinsho/bufferline.nvim' }
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
	use { 'junegunn/vim-easy-align' }
	use { 'eraserhd/parinfer-rust' }
	use { 'nvim-lua/plenary.nvim' }
	use { 'nvim-telescope/telescope.nvim' }

	-- Language support
	use { 'sheerun/vim-polyglot' }
	use { 'tridactyl/vim-tridactyl' }
	use { 'elkowar/yuck.vim' }
	use { 'fladson/vim-kitty' }
	use { 'baskerville/vim-sxhkdrc' }

	-- Color Schemes
	use { 'joshdick/onedark.vim' }
	use { 'ellisonleao/gruvbox.nvim' }
	use { 'doums/darcula' }
	use { 'vim-airline/vim-airline' }
	use { 'vim-airline/vim-airline-themes' }
	use { 'rainglow/vim' }
	use { 'drewtempelmeyer/palenight.vim' }
end)
-- END Plugins }}}

-- Options {{{

-- Colors
opt.background = "dark"
cmd "colorscheme gruvbox"
opt.termguicolors = true

opt.number = true
opt.foldmethod = "marker"
opt.clipboard = "unnamedplus"
opt.expandtab = true
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.wildmode = {'list', 'longest'}
vim.wo.wrap = true
opt.linebreak = true
vim.wo.list = false -- Don't wrap in the middle of a word
-- opt.whichwrap:append('<>hl')

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank { timeout = 800 }
  end,
  desc = "Provide a visual feedback on copying.",
})

-- END Options }}}

-- Plugin config {{{

-- Airline
g.airline_powerline_fonts = 1
g.airline_theme = 'deus'

-- END Plugin config }}}

-- Vimscript {{{
cmd [[

" set wrap linebreak nolist " Don't wrap in the middle of a word
set mouse=a


" Remaps {{{

" j and k go up/down wrapped lines
map j gj
map k gk
map <Up> g<Up>
map <Down> g<Down>

" Space Leader
let mapleader=" "

" Leader stuff
nnoremap <Leader>w :w<cr>
nnoremap <Leader>q :q<cr>
nnoremap <Leader>Q :q!<cr>
nnoremap <Leader>x :x<cr>
nnoremap <Leader>c :bd<cr>
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

" dd doesn't cut but deletes. Use Vx to cut line
nnoremap d "_d
vnoremap d "_d
" x doesn't cut but deletes. Not in visual mode though.
nnoremap x "_x
" c doesn't cut but deletes, fucking hell.
nnoremap c "_c
"
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Move across buffers with Meh
nnoremap <silent><M-CR> :BufferLineCyclePrev<cr>
nnoremap <silent><M-C-S-Tab> :BufferLineCycleNext<cr>

" }}}

" Plugin configs {{{

" Sneak {{{

let g:sneak#label = 1

" case insensitive sneak
let g:sneak#use_ic_scs = 1

" immediately move to the next instance of search, if you move the cursor sneak is back to default behavior
let g:sneak#s_next = 1

" remap so I can use , and ; with f and t
map gS <Plug>Sneak_,
map gs <Plug>Sneak_;

" Change the colors
" highlight Sneak guifg=black guibg=#00C7DF ctermfg=black ctermbg=cyan
" highlight SneakScope guifg=red guibg=yellow ctermfg=red ctermbg=yellow

" Cool prompts
let g:sneak#prompt = '🕵'
let g:sneak#prompt = '🔎'

" I like quickscope better for this since it keeps me in the scope of a single line
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

" END Sneak }}}

" Telescope {{{
" Find files using Telescope command-line sugar.
nnoremap <C-Space> <cmd>Telescope find_files<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
" END Telescope }}}

" bufferline
lua << EOF
require("bufferline").setup{}
EOF

" Nerdcommenter stuff
let NERDSpaceDelims=1 " Add spaces with comments

" Auto-pairs
let g:AutoPairsMultilineClose = 0

" END Plugin configs }}}

]]
-- END Vimscript }}}

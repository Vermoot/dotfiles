require "dots.options"
require "dots.plugins"
require "dots.keymaps"
require "dots.cmp"
require "dots.lsp"
require "dots.rnvimr"
require "dots.treesitter"
require "dots.bufferline"
require "dots.markdown-preview"

local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

-- Plugin config {{{

-- Airline
g.airline_powerline_fonts = 1
g.airline_theme = 'deus'


-- END Plugin config }}}

-- Vimscript {{{
cmd [[


" Remaps {{{

" j and k go up/down wrapped lines
" map j gj
" map k gk
" map <Up> g<Up>
" map <Down> g<Down>

" Space Leader
" let mapleader=" "

" Leader stuff
" nnoremap <Leader>w :w<cr>
" nnoremap <Leader>q :q<cr>
" nnoremap <Leader>Q :q!<cr>
" nnoremap <Leader>x :x<cr>
" nnoremap <Leader>c :bd<cr>

" dd doesn't cut but deletes. Use Vx to cut line
" nnoremap d "_d
" vnoremap d "_d
" x doesn't cut but deletes. Not in visual mode though.
" nnoremap x "_x
" c doesn't cut but deletes, fucking hell.
" nnoremap c "_c
"
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Move across buffers with Meh
" nnoremap <silent><M-CR> :BufferLineCyclePrev<cr>
" nnoremap <silent><M-C-S-Tab> :BufferLineCycleNext<cr>

" }}}

" Plugin configs {{{

" Sneak {{{

let g:sneak#label = 1
let g:sneak#target_labels = "tnseridhaofuwy"

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
nnoremap f <Plug>Sneak_f
nnoremap F <Plug>Sneak_F
nnoremap t <Plug>Sneak_t
nnoremap T <Plug>Sneak_T

" END Sneak }}}

" Telescope {{{
" Find files using Telescope command-line sugar.
nnoremap <C-Space> <cmd>Telescope find_files<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
" END Telescope }}}


" Nerdcommenter stuff
let NERDSpaceDelims=1 " Add spaces with comments

" Auto-pairs
let g:AutoPairsMultilineClose = 0

" END Plugin configs }}}

]]
-- END Vimscript }}}

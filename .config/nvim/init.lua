-- Plugins {{{
require 'packer'.startup(function(use)
	use 'machakann/vim-highlightedyank'
	use 'psliwka/vim-smoothie'
	use 'unblevable/quick-scope'
	use 'ap/vim-css-color'
	use 'glacambre/firenvim'
	use 'tpope/vim-surround'
	use 'wellle/targets.vim'
	use 'jiangmiao/auto-pairs'
	use 'justinmk/vim-sneak'
	use 'kien/rainbow_parentheses.vim'
	use 'sheerun/vim-polyglot'
	use 'alvan/vim-closetag'
	use 'tpope/vim-repeat'
	use 'liuchengxu/vim-which-key'
	use 'preservim/nerdcommenter'
	use 'iamcco/markdown-preview.nvim'
	use 'tridactyl/vim-tridactyl'
	use 'kyazdani42/nvim-web-devicons'
	use 'akinsho/bufferline.nvim'
	use 'elkowar/yuck.vim'
	use 'fladson/vim-kitty'
	use 'baskerville/vim-sxhkdrc'
	use 'junegunn/vim-easy-align'
	use 'eraserhd/parinfer-rust'
	use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'

	-- Color Schemes
	use 'joshdick/onedark.vim'
	use 'morhetz/gruvbox'
	use 'doums/darcula'
	use 'vim-airline/vim-airline'
	use 'vim-airline/vim-airline-themes'
	use 'rainglow/vim'
	use 'drewtempelmeyer/palenight.vim'
end)
-- END Plugins }}}

vim.cmd [[

set background=dark
colorscheme gruvbox
" let g:gruvbox_contrast_dark
let g:airline_powerline_fonts = 1
let g:airline_theme='deus'

set termguicolors
set foldmethod=marker
set number
set clipboard=unnamedplus  " Sync clipboard and default register
set whichwrap+=<,>,h,l " Allow arrows and h/l to move to the previous/next line
set wrap linebreak nolist " Don't wrap in the middle of a word
set mouse=a
set expandtab

" bufferline
lua << EOF
require("bufferline").setup{}
EOF

" Nerdcommenter stuff
let NERDSpaceDelims=1 " Add spaces with comments

" Auto-pairs
let g:AutoPairsMultilineClose = 0

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

"Plugin configs {{{

"}}}

" " coc.nvim {{{

" " TextEdit might fail if hidden is not set.
" set hidden

" " Some servers have issues with backup files, see #649.
" set nobackup
" set nowritebackup

" " Give more space for displaying messages.
" " set cmdheight=2

" " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" " delays and poor user experience.
" set updatetime=300

" " Don't pass messages to |ins-completion-menu|.
" set shortmess+=c

" " Always show the signcolumn, otherwise it would shift the text each time
" " diagnostics appear/become resolved.
" if has("patch-8.1.1564")
  " " Recently vim can merge signcolumn and number column into one
  " set signcolumn=number
" else
  " set signcolumn=yes
" endif

" " Use tab for trigger completion with characters ahead and navigate.
" " NOTE: Use command ':verbose imap<tab>' to make sure tab is not mapped by
" " other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
      " \ pumvisible() ? "\<C-n>" :
      " \ <SID>check_back_space() ? "\<TAB>" :
      " \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
  " let col = col('.') - 1
  " return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" " Use <c-space> to trigger completion.
" if has('nvim')
  " inoremap <silent><expr> <c-space> coc#refresh()
" else
  " inoremap <silent><expr> <c-@> coc#refresh()
" endif

" " Make <CR> auto-select the first completion item and notify coc.nvim to
" " format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              " \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" " Use `[g` and `]g` to navigate diagnostics
" " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)

" " GoTo code navigation.
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" " Use K to show documentation in preview window.
" nnoremap <silent> K :call <SID>show_documentation()<CR>

" function! s:show_documentation()
  " if (index(['vim','help'], &filetype) >= 0)
    " execute 'h '.expand('<cword>')
  " elseif (coc#rpc#ready())
    " call CocActionAsync('doHover')
  " else
    " execute '!' . &keywordprg . " " . expand('<cword>')
  " endif
" endfunction

" " Highlight the symbol and its references when holding the cursor.
" autocmd CursorHold * silent call CocActionAsync('highlight')

" " Symbol renaming.
" nmap <leader>rn <Plug>(coc-rename)

" " Formatting selected code.
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

" augroup mygroup
  " autocmd!
  " " Setup formatexpr specified filetype(s).
  " autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " " Update signature help on jump placeholder.
  " autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end

" " Applying codeAction to the selected region.
" " Example: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

" " Remap keys for applying codeAction to the current buffer.
" nmap <leader>ac  <Plug>(coc-codeaction)
" " Apply AutoFix to problem on the current line.
" nmap <leader>qf  <Plug>(coc-fix-current)

" " Map function and class text objects
" " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
" xmap if <Plug>(coc-funcobj-i)
" omap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap af <Plug>(coc-funcobj-a)
" xmap ic <Plug>(coc-classobj-i)
" omap ic <Plug>(coc-classobj-i)
" xmap ac <Plug>(coc-classobj-a)
" omap ac <Plug>(coc-classobj-a)

" " Remap <C-f> and <C-b> for scroll float windows/popups.
" if has('nvim-0.4.0') || has('patch-8.2.0750')
  " nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  " nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  " inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  " inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  " vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  " vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" endif

" " Use CTRL-S for selections ranges.
" " Requires 'textDocument/selectionRange' support of language server.
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)

" " Add `:Format` command to format current buffer.
" command! -nargs=0 Format :call CocAction('format')

" " Add `:Fold` command to fold current buffer.
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" " Add `:OR` command for organize imports of the current buffer.
" command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" " Add (Neo)Vim's native statusline support.
" " NOTE: Please see `:h coc-status` for integrations with external plugins that
" " provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" " Mappings for CoCList
" " Show all diagnostics.
" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions.
" nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" " Show commands.
" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document.
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols.
" nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list.
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR> 

" " }}}

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

" }}}

" Telescope {{{
" Find files using Telescope command-line sugar.
nnoremap <C-Space> <cmd>Telescope find_files<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
"}}}

" }}}

]]
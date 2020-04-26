execute pathogen#infect()
set background=dark
set termguicolors
colorscheme material-monokai
" Soft tabs
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set number
syntax on
filetype plugin indent on
au BufNewFile,BufRead *.es6 set filetype=javascript
" Escape out of insert and visual mode with jk or kj
inoremap jk <Esc>
inoremap kj <Esc>
vnoremap jk <Esc>
vnoremap kj <Esc>
" Stop using arrow keys
nnoremap <Left> <nop>
nnoremap <Right> <nop>
nnoremap <Up> <nop>
nnoremap <Down> <nop>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_es6_checkers = ['eslint']
let g:syntastic_js_checkers = ['eslint']
" Ack >> Don't print on terminal
set shellpipe=>
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
set rtp+=/usr/local/opt/fzf

" break line mappings
nnoremap <NL> i<CR><ESC>
" mapings for rg vim plugin
nnoremap <silent> <Leader>f :call FindTextPrompt()<CR>

nnoremap <C-p> :FZF<CR>
nnoremap <Leader>i :JSImport<CR>
set rnu

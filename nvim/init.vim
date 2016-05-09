"" hodduc(Joonsung Lee)'s init.vim file
"" hodduc at hodduc.net


" Plugins --------------------------------------------------------------------
call plug#begin('~/.config/nvim/plugged')

"" Base plugins
Plug 'tpope/vim-sensible'

"" UI integration & Color Schemes
Plug 'molokai'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'tpope/vim-vinegar'
" Plug 'fholgado/minibufexpl.vim'

"" Language-specific packs
Plug 'klen/python-mode'
Plug 'fatih/vim-go'
Plug 'ekalinin/Dockerfile.vim'
Plug 'cstrahan/vim-capnp'

"" Syntactic Helpers
Plug 'Valloric/YouCompleteMe'

call plug#end()


" Load colorscheme if exists -------------------------------------------------
try
  colorscheme molokai
catch /^Vim\%((\a\+)\)\=:E185/
  echo 'colorscheme molokai not exist'
endtry

" Pre-load sensible.vim to override some features
runtime! plugin/sensible.vim


" Plugin Settings ------------------------------------------------------------

"" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
" let g:airline_theme = 'powerlineish'

"" vim-go
let g:go_fmt_command = "goimports"
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_structs = 1
" let g:go_auto_type_info = 1

"" python-mode
let g:pymode_folding = 0
let g:pymode_rope = 0
let g:pymode_lint = 1
let g:pymode_lint_checkers = ['pyflakes', 'pep8']
let g:pymode_lint_ignore = "E501,E261"
let g:pymode_options_max_line_length = 99
let g:pymode_lint_unmodified = 1
let g:pymode_lint_options_pep8 = {'max_line_length': g:pymode_options_max_line_length}
let g:pymode_lint_options_pylint = {'max-line-length': g:pymode_options_max_line_length}

"" YouCompleteMe
""" turn off YouCompleteMe identifier based completion
let g:ycm_min_num_of_chars_for_completion = 99
let g:ycm_key_invoke_completion = '<C-l>'


" Global settings ------------------------------------------------------------
"" Overrides vim-sensible. See `:help ttimeoutlen`.
""" This option stands to accept escape characters (i.e. Page UP, ... ) on 
""" slow connection, but annoying in local... This should be fixed after
""" merging https://github.com/neovim/neovim/pull/3982 .
set ttimeoutlen=0

set nu nuw=6 ru sc wrap ls=2 lz           " -- appearance
set noet bs=2 ts=8 sw=8 sts=0  	          " -- tabstop
set noai nosi hls is ic cf ws scs magic   " -- search
set sol sel=inclusive mps+=<:>            " -- moving around
set ut=10 uc=200                          " -- swap control
set report=0 lpl wmnu                     " -- misc.

set cursorline                            " -- highlight current line

"" filetype-specific configurations
au FileType cpp setl ts=2 sw=2 sts=2 et
au FileType python setl ts=8 sw=4 sts=4 et
au Filetype text setl tw=80
au FileType javascript,jsp setl cin
au FileType html,htmldjango setl ts=2 sts=2 sw=2 et
au FileType go setl ts=4 sts=4 sw=4
au BufNewFile,BufRead *.gbp setf json
au BufNewFile,BufRead *.phps,*.php3s setf php

"" syntax extensions (see prior section for definition)
au Syntax html call s:SyntaxExtHTML()
au Syntax * syn sync minlines=500 maxlines=1000

set list listchars=tab:»\ ,trail:·,extends:>,precedes:<,nbsp:+

" Key mapping ----------------------------------------------------------------
nmap <silent> <C-j> :bn<CR>
nmap <silent> <C-k> :bN<CR>
nmap mv :set mouse=v<CR>
nmap ma :set mouse=a<CR>
nmap <silent> <C-h> :e %<.h<CR>
nmap <silent> <C-l> :e %<.cc<CR>

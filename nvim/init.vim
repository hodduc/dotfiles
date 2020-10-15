"" hodduc(Joonsung Lee)'s init.vim file
"" hodduc at hodduc.net


" Plugins --------------------------------------------------------------------
call plug#begin('~/.local/share/nvim/plugged')

"" Base plugins
Plug 'tpope/vim-sensible'

"" UI integration & Color Schemes
Plug 'fatih/molokai'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'tpope/vim-vinegar'
Plug 'justinmk/vim-dirvish'

" Plug 'fholgado/minibufexpl.vim'

"" Language-specific packs
Plug 'python-mode/python-mode', { 'branch': 'develop' }
Plug 'fatih/vim-go'
Plug 'ekalinin/Dockerfile.vim'
Plug 'cstrahan/vim-capnp'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'alvan/vim-closetag'
Plug 'posva/vim-vue'
Plug 'hashivim/vim-terraform'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'PProvost/vim-ps1'

"" Generic Syntactic Helpers
" Plug 'Valloric/YouCompleteMe'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'w0rp/ale'

function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

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
let g:go_def_mapping_enabled = 0  " replaced with coc.nvim
let g:go_info_mode='gopls'
" let g:go_auto_type_info = 1

"" python-mode
let g:pymode_folding = 0
let g:pymode_rope = 0
"let g:pymode_rope_goto_definition_bind = '<leader>g'
"let g:pymode_rope_goto_definition_cmd = 'e'
"let g:pymode_rope_complete_on_dot = 0
let g:pymode_lint = 1
let g:pymode_python = 'python3'
let g:pymode_lint_checkers = ['pyflakes', 'pep8']
let g:pymode_lint_ignore = ["E501","E261","E266","C0111","W0401","W0614","R0201","W0511","C0302","R0911","C0302","R0914","W0212"]
let g:pymode_options_max_line_length = 129
let g:pymode_lint_unmodified = 1
let g:pymode_lint_options_pep8 = {'max_line_length': g:pymode_options_max_line_length}
let g:pymode_lint_options_pylint = {'max-line-length': g:pymode_options_max_line_length}

"" vim-terraform
let g:terraform_fmt_on_save = 1

"" YouCompleteMe
""" turn off YouCompleteMe identifier based completion
" let g:ycm_min_num_of_chars_for_completion = 99
" let g:ycm_key_invoke_completion = '<C-l>'

"" Use deoplete.
" let g:deoplete#enable_at_startup = 1
" let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'

"" vim-closetag
let g:closetag_filenames = "*.html,*.xhtml,*.jsx,*.js"

"" vim-jsx
let g:jsx_ext_required = 0

"" ale
" disable python linter to avoid conflict with python-mode
let g:ale_linters = {
\   'python': [],
\   'go': ['gometalinter', 'go vet', 'gopls'],
\   'javascript': ['eslint'],
\}
let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'css': ['prettier'],
\}

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_open_list = 1
let g:ale_list_window_size = 6
let g:ale_echo_msg_format = '%code: %%s (%linter%)'
let g:ale_go_gometalinter_options = '--no-config --disable-all --aggregate --enable=gofmt --enable=goimports --exclude="not gofmted with -s"'  " --enable=errcheck 

" If popup menu is visible, select and insert next item
" Otherwise, insert tab character
" Ref: https://github.com/rafi/vim-config/blob/master/config/plugins/deoplete.vim

" inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>"
"   \ : "\<Tab>"
"  \ deoplete#mappings#manual_complete()

"" ctags
set tags=./tags,tags;$HOME  " find "tags" file from CWD to $HOME


" Global settings ------------------------------------------------------------
"" Overrides vim-sensible. See `:help ttimeoutlen`.
""" This option stands to accept escape characters (i.e. Page UP, ... ) on 
""" slow connection, but annoying in local... This should be fixed after
""" merging https://github.com/neovim/neovim/pull/3982 .
set ttimeoutlen=0

set nu nuw=6 ru sc wrap ls=2 lz           " -- appearance
set noet bs=2 ts=2 sw=2 sts=0  	          " -- tabstop
set noai nosi hls is ic cf ws scs magic   " -- search
set sol sel=inclusive mps+=<:>            " -- moving around
set ut=10 uc=200                          " -- swap control
set report=0 lpl wmnu                     " -- misc.

" set cursorline                            " -- highlight current line  --slow!

set autoread                              " -- auto reload when file has changed outside of vim
set exrc secure                           " -- allow project-specific .vimrc

set undodir=~/.vim/undodir                " -- preserve undo history
set undofile                              " -- (see :help undo-persistence)

" exclude quickfix from ':bnext', ':bprevious'
" See :help 'buflisted'

augroup qf
  autocmd!
  autocmd FileType qf set nobuflisted
augroup END

augroup netrw
  autocmd!
  autocmd FileType netrw set nobuflisted
augroup END


"" filetype-specific configurations
au FileType c,cpp setl ts=2 sw=2 sts=2
au FileType vue setl ts=2 sw=2 sts=2 et
au FileType python setl ts=8 sw=4 sts=4 et
au Filetype text setl tw=80
au FileType typescript.tsx,typescript,javascript,jsp,jsx setl cin ts=2 sts=2 sw=2 et
au FileType html,htmldjango setl ts=2 sts=2 sw=2 et
au FileType go setl ts=4 sts=4 sw=4
au FileType ruby setl ts=2 sts=2 sw=2 et
au FileType terraform setl ts=2 sts=2 sw=2 et
au BufNewFile,BufRead *.gbp setf json
au BufNewFile,BufRead *.phps,*.php3s setf php

"" syntax extensions (see prior section for definition)
au Syntax html call s:SyntaxExtHTML()
au Syntax * syn sync minlines=500 maxlines=1000

set list listchars=tab:»\ ,trail:·,extends:>,precedes:<,nbsp:+

"" Specify python host for neovim. The 'neovim' package should be installed in
"" that environment. (from wookayin/dotfiles)
let g:python_host_prog  = '/usr/local/bin/python'
if empty(glob(g:python_host_prog))
  " Fallback if not exists
  let g:python_host_prog = '/usr/bin/python'
endif

let g:python3_host_prog = '/usr/local/bin/python3'
if empty(glob(g:python3_host_prog))
  " Fallback if not exists
  let g:python3_host_prog = '/usr/bin/python3'
endif

if empty(glob(g:python3_host_prog)) && executable("python3")
  " Fallback to local/venv python3 if not exists
  let g:python3_host_prog = substitute(system("which python3"), '\n\+$', '', '')
endif

" Key mapping ----------------------------------------------------------------
" change leader key to Space: Nobody uses Space for navigation
let mapleader = "\<Space>"

" useful keymaps
nnoremap <silent> <C-j> :bn<CR>
nnoremap <silent> <C-k> :bN<CR>
nnoremap mv :set mouse=v<CR>
nnoremap ma :set mouse=a<CR>
nnoremap <silent> <C-h> :e %<.h<CR>
nnoremap <silent> <C-l> :e %<.cc<CR>
nnoremap <leader>d "_d
vnoremap <leader>d "_d

if filereadable(glob("~/.nvimrc_local"))
  source ~/.nvimrc_local
endif

if filereadable(stdpath('config').'coc_config.vim')
  source stdpath('config').'coc_config.vim'
endif

redrawstatus  " to fix a bug on coloring command line (nvim 0.4.3 maybe?)

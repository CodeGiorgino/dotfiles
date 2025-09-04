" Map leader to ,
let mapleader=','

" *****************************************************************************
"  Plugins
" *****************************************************************************
call plug#begin()
    Plug 'tpope/vim-sensible'
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/vim-easy-align'
    Plug 'voldikss/vim-floaterm'
    Plug 'girishji/vimsuggest'
    Plug 'dense-analysis/ale'
    Plug 'ilyachur/cmake4vim'

    " colorschemes
    Plug 'morhetz/gruvbox'

    " filetypes
    Plug 'jlcrochet/vim-razor'
call plug#end()

" fugitive
noremap <Leader>ga :Gwrite<CR>
noremap <Leader>gc :Git commit --verbose<CR>
noremap <Leader>gsh :Git push<CR>
noremap <Leader>gll :Git pull<CR>
noremap <Leader>gs :Git<CR>
noremap <Leader>gb :Git blame<CR>
noremap <Leader>gd :Gvdiffsplit<CR>
noremap <Leader>gr :GRemove<CR>

" fzf
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__

let $FZF_DEFAULT_COMMAND = "bash -c \"find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o -path 'bin/**' -prune -o -path 'obj/**' -prune -o -type f -print -o -type l -print 2> /dev/null\""

nnoremap <Leader>ff :Files   <CR>
nnoremap <Leader>fg :GFiles  <CR>
nnoremap <Leader>fb :Buffers <CR>

" ripgrep
set grepprg=rg\ --vimgrep
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
nnoremap <Leader>rg :Find <CR>

" floaterm
nnoremap <C-j> :FloatermToggle <CR>
tnoremap <C-j> <C-\><C-n>:FloatermToggle <CR>

" easy-align
vnoremap <Leader>al :EasyAlign <CR>

" vimsuggest
let s:vim_suggest = {}
let s:vim_suggest.cmd = {
    \ 'enable': v:true,
    \ 'pum': v:true,
    \ 'exclude': [],
    \ 'onspace': ['b\%[uffer]','colo\%[rscheme]'],
    \ 'alwayson': v:true,
    \ 'popupattrs': {},
    \ 'wildignore': v:true,
    \ 'addons': v:true,
    \ 'trigger': 't',
    \ 'reverse': v:false,
    \ 'prefixlen': 1,
\ }
let s:vim_suggest.search = {
    \ 'enable': v:true,
    \ 'pum': v:true,
    \ 'fuzzy': v:false,
    \ 'alwayson': v:true,
    \ 'popupattrs': {
    \   'maxheight': 12
    \ },
    \ 'range': 100,
    \ 'timeout': 200,
    \ 'async': v:true,
    \ 'async_timeout': 3000,
    \ 'async_minlines': 1000,
    \ 'highlight': v:true,
    \ 'trigger': 't',
    \ 'prefixlen': 1,
\ }

" ale
set signcolumn=yes
let g:ale_enabled = 0
let g:ale_virtualtext_cursor = 'disabled'
let g:ale_completion_enabled = 0

nnoremap K <cmd>ALEHover<CR>
nnoremap <leader>gtd <cmd>ALEGoToDefinition<CR>
nnoremap <leader>gtr <cmd>ALEFindReferences<CR>

" cmake4vim
let g:cmake_build_args = '--parallel 10'
let g:make_arguments = '-j 10'

" *****************************************************************************
" Config
" *****************************************************************************

" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set ttyfast

" Fix backspace indent
set backspace=indent,eol,start

" Tabs. May be overridden by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

" Enable hidden buffers
set hidden

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

set fileformats=unix,dos,mac

" session management
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

" *****************************************************************************
"  Visual Settings
" *****************************************************************************
syntax on
set ruler
set rnu
set number
set colorcolumn=80

set guifont=JetBrains\ Mono\ Medium:h11
au GUIEnter * simalt ~x

let no_buffers_menu=1
set termguicolors
set bg=dark
colorscheme gruvbox

let g:netrw_preview   = 1
let g:netrw_liststyle = 3
let g:netrw_winsize   = 30

" Better command line completion 
set wildmenu

" mouse support
set mouse=a

set mousemodel=popup
set t_Co=256
set guioptions=egmrti

set scrolloff=20

" Status bar
set laststatus=2

" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F

set statusline=%F%m%r%h%w%=[%{&ff}/%Y]\ [%l\/%L]\ [%{strftime('%Y-%m-%d\ %H:%M')}]

" *****************************************************************************
"  Abbreviations
" *****************************************************************************
" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" *****************************************************************************
"  Autocmd Rules
" *****************************************************************************
" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
    autocmd!
      autocmd BufEnter * :syntax sync maxlines=200
augroup END

" Remember cursor position
augroup vimrc-remember-cursor-position
    autocmd!
      autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" make/cmake
augroup vimrc-make-cmake
    autocmd!
      autocmd FileType make setlocal noexpandtab
        autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

set autoread

" *****************************************************************************
"  Mappings
" *****************************************************************************

noremap  <Space> :
inoremap <silent> <C-s> <C-C>:update<CR>
vnoremap <silent> <C-s> <C-O>:update<CR>

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv
noremap <Leader><Space> :nohl<CR>
noremap  <silent> <C-s> :update<CR>

" Session management
nnoremap <leader>so :OpenSession<Space>
nnoremap <leader>ss :SaveSession<Space>
nnoremap <leader>sd :DeleteSession<CR>
nnoremap <leader>sc :CloseSession<CR>

" Tabs
nnoremap <silent> <Tab> :tabnext<CR>
nnoremap <silent> <C-t> :tabnew<CR>

" Buffers
nnoremap <Leader>bn :bnext     <CR>
nnoremap <Leader>bp :bprevious <CR>
nnoremap <Leader>bd :bdelete   <CR>
nnoremap <Leader>bD :bdelete!  <CR>

" Copy/Paste/Cut
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
endif

" copy to clipboard
vnoremap <C-c> ::w !clip.exe<CR><CR>

noremap YY "+y <CR>
noremap <leader>p "+gP <CR>

" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

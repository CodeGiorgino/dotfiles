" Map leader to ,
let mapleader=','

" *****************************************************************************
"  Plugins
" *****************************************************************************
call plug#begin()
    Plug 'tpope/vim-sensible'

    Plug 'xolox/vim-misc'
    Plug 'xolox/vim-session'

    Plug 'tpope/vim-fugitive'
    " noremap <leader>ga:  Gwrite<cr>
    " noremap <leader>gc:  Git commit --verbose<cr>
    " noremap <leader>gsh: Git push<cr>
    " noremap <leader>gll: Git pull<cr>
    " noremap <leader>gs:  Git<cr>
    " noremap <leader>gb:  Git blame<cr>
    " noremap <leader>gd:  Gvdiffsplit<cr>
    " noremap <leader>gr:  GRemove<cr>

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    nnoremap <leader>ff :Files   <cr>
    nnoremap <leader>fg :GFiles  <cr>
    nnoremap <leader>fb :Buffers <cr>

    Plug 'junegunn/vim-easy-align'
    vnoremap <leader>al :LiveEasyAlign <cr>

    Plug 'voldikss/vim-floaterm'
    nnoremap <C-j> :FloatermToggle <cr>
    tnoremap <C-j> <C-\><C-n>:FloatermToggle <cr>

    Plug 'girishji/vimsuggest'
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

    Plug 'dense-analysis/ale'
    set signcolumn=yes
    let g:ale_completion_enabled = 0
    let g:ale_enabled = 0
    let g:ale_fixers = ['clang-format']
    let g:ale_virtualtext_cursor = 'disabled'
    nnoremap K <cmd>ALEHover<cr>
    nnoremap gtd <cmd>ALEGoToDefinition<cr>
    nnoremap gtr <cmd>ALEFindReferences<cr>

    Plug 'ilyachur/cmake4vim'
    let g:cmake_build_args = '--parallel 10'
    let g:cmake_build_dir = 'build'
    let g:cmake_build_executor_window_size = 30
    let g:make_arguments = '-Wall -Wextra -j 10'
    noremap <C-b> <Cmd>CMakeBuild<cr>

    Plug 'vim-airline/vim-airline'

    Plug 'mattn/emmet-vim'

    " colorschemes
    Plug 'morhetz/gruvbox'
call plug#end()

set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__

let $FZF_DEFAULT_COMMAND = "bash -c \"find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o -path 'bin/**' -prune -o -path 'obj/**' -prune -o -type f -print -o -type l -print 2> /dev/null\""

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

noremap  <space> :

noremap  <silent> <C-s> <cmd>update<cr>
xnoremap <silent> s     <cmd>'<,'>sort<cr>

inoremap <silent> <C-s> <C-c>:update<cr>
vnoremap <silent> <C-s> <C-o>:update<cr>

" Search mappings
nnoremap n nzzzv
nnoremap N Nzzzv
noremap <leader><space> :nohl<cr>

set grepprg=rg\ --vimgrep
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
nnoremap <leader>rg :Find <cr>

" Session management
nnoremap <leader>so :OpenSession<space>
nnoremap <leader>ss :SaveSession<space>
nnoremap <leader>sd :DeleteSession<cr>
nnoremap <leader>sc :CloseSession<cr>

" Tabs
nnoremap <silent> <tab> :tabnext<cr>
nnoremap <silent> T     :tabnew<cr>

" Buffers
nnoremap <leader>bn :bnext     <cr>
nnoremap <leader>bp :bprevious <cr>
nnoremap <leader>bd :bdelete   <cr>
nnoremap <leader>bD :bdelete!  <cr>

" Copy/Paste/Cut
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
endif

" copy to clipboard
vnoremap <C-c> ::w !clip.exe<cr><cr>

noremap YY "+y <cr>
noremap <leader>p "+gP <cr>

" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

let mapleader=','

" *****************************************************************************
"  Plugins
" *****************************************************************************
"
call plug#begin()
    Plug 'xolox/vim-misc'

    Plug 'xolox/vim-session'
    let g:session_autoload = 'no'
    let g:session_autosave = 'no'
    let g:session_command_aliases = 1
    let g:session_directory = '~/.vim/session'

    nnoremap <leader>so :OpenSession<space>
    nnoremap <leader>ss :SaveSession<space>
    nnoremap <leader>sd <cmd>DeleteSession<cr>
    nnoremap <leader>sc <cmd>CloseSession<cr>

    Plug 'tpope/vim-sensible'
    Plug 'tpope/vim-fugitive'
    " noremap <leader>ga  <cmd>Gwrite<cr>
    " noremap <leader>gc  <cmd>Git commit --verbose<cr>
    " noremap <leader>gsh <cmd>Git push<cr>
    " noremap <leader>gll <cmd>Git pull<cr>
    " noremap <leader>gs  <cmd>Git<cr>
    " noremap <leader>gb  <cmd>Git blame<cr>
    " noremap <leader>gd  <cmd>Gvdiffsplit<cr>
    " noremap <leader>gr  <cmd>GRemove<cr>

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    nnoremap <leader>ff <cmd>Files<cr>
    nnoremap <leader>fg <cmd>GFiles<cr>
    nnoremap <leader>fb <cmd>Buffers<cr>

    Plug 'junegunn/vim-easy-align'
    vnoremap <leader>al <cmd>LiveEasyAlign<cr>

    Plug 'voldikss/vim-floaterm'
    nnoremap <C-t> <cmd>terminal<cr>
    nnoremap <C-j> <cmd>FloatermToggle<cr>
    tnoremap <C-j> <cmd>FloatermToggle<cr>

    Plug 'dense-analysis/ale'
    let g:ale_completion_enabled = 0
    let g:ale_enabled = 0
    let g:ale_fixers  = [
                \   'clang-format'
                \ ]
    let g:ale_virtualtext_cursor = 'disabled'
    nnoremap K <cmd>ALEHover<cr>
    nnoremap gtd <cmd>ALEGoToDefinition<cr>
    nnoremap gtr <cmd>ALEFindReferences<cr>

    Plug 'ilyachur/cmake4vim'
    let g:cmake_build_args = '--parallel 10'
    let g:cmake_build_dir  = 'build'
    let g:cmake_build_executor_window_size = 30

    Plug 'vim-airline/vim-airline'

    Plug 'mattn/emmet-vim'

    Plug 'Townk/vim-autoclose'

    " colorschemes
    Plug 'morhetz/gruvbox'
call plug#end()

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
set expandtab
set shiftwidth=4
set softtabstop=0
set tabstop=4

" Enable hidden buffers
set hidden

" Searching
set fileformats=unix,dos,mac
set hlsearch
set ignorecase
set incsearch

" *****************************************************************************
"  Visual Settings
" *****************************************************************************

syntax on
set autoread
set ruler
set rnu
set number
set colorcolumn=80
set cursorline
set signcolumn=yes

set guifont=JetBrains\ Mono\ Medium:h11
au GUIEnter * simalt ~x

let no_buffers_menu = 1
set termguicolors
set bg=dark
colorscheme gruvbox

let g:netrw_preview   = 1
let g:netrw_liststyle = 3
let g:netrw_winsize   = 30

" Cmdline autocompletion 
set wildignorecase
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
set wildmenu
set wildmode=noselect:lastused,full
set wildoptions=pum
autocmd CmdlineChanged [:\/\?] call wildtrigger()

" Insert mode autocompletion
set autocomplete
set complete=.^5,w^5,b^5,u^5
set completeopt=popup
inoremap <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" mouse support
set guioptions=egmrti
set mouse=a
set mousemodel=popup
set scrolloff=20
set t_Co=256

" Status bar
set laststatus=2
set statusline=%F%m%r%h%w%=[%{&ff}/%Y]\ [%l\/%L]\ [%{strftime('%Y-%m-%d\ %H:%M')}]
set title
set titleold="Terminal"

" Use modeline overrides
set modeline
set modelines=10
set titlestring=%F

" *****************************************************************************
"  Abbreviations
" *****************************************************************************

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

" *****************************************************************************
"  Other mappings
" *****************************************************************************

noremap <space> :

xnoremap s :sort<cr>

nnoremap <C-s> <cmd>update<cr>
inoremap <C-s> <esc><cmd>update<cr>
vnoremap <C-s> <esc><cmd>update<cr>

" Search mappings
nnoremap n nzzzv
nnoremap N Nzzzv

set grepprg=rg\ --vimgrep
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
nnoremap <leader>rg <cmd>Find<cr>

" Tabs
nnoremap <pageup> <cmd>tabprevious<cr>
nnoremap <pagedown> <cmd>tabnext<cr>
nnoremap T <cmd>tabnew<cr>

" Buffers
nnoremap <leader>bn <cmd>bnext<cr>
nnoremap <leader>bp <cmd>bprevious<cr>
nnoremap <leader>bd <cmd>bdelete<cr>
nnoremap <leader>bD <cmd>bdelete!<cr>

" Copy
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
endif

vnoremap <C-c> y<cmd>call system('clip.exe', @")<cr>

" Include user's local vim config
if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif

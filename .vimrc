" --------------------
" Initialize NeoBundle
" --------------------
set nocompatible

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/unite.vim'
    " Use Ag (Silver Searcher) instead of Ack when using Unite's search feature
    if executable('ag')
        let g:unite_source_grep_command='ag'
        let g:unite_source_grep_default_opts = '--line-numbers --nocolor --nogroup --hidden'
        let g:unite_source_grep_recursive_opt=''
    endif

    " Ignore the following files/directories
    call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
                \ 'ignore_pattern', join([
                \ '\.git/',
                \ '\.svn/',
                \ '\.hg/',
                \ '*.swp',
                \ '*.bak',
                \ '*.pyc',
                \ '*.class',
                \ '*.so',
                \ ], '\|'))

    " Enable fuzzy matching
    call unite#filters#matcher_default#use(['matcher_fuzzy'])

    " Enable rank sorter
    call unite#filters#sorter_default#use(['sorter_rank'])

    let g:unite_split_rule = "botright"
    let g:unite_force_overwrite_statusline = 0
    let g:unite_winheight = 10

    autocmd FileType unite call s:unite_settings()

    function! s:unite_settings()
        imap <buffer> <ESC> <Plug>(unite_exit)

        imap <buffer> <C-j> <Plug>(unite_select_next_line)
        imap <buffer> <C-k> <Plug>(unite_select_previous_line)
        imap <silent><buffer><expr> <C-x> unite#do_action('split')
        imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
    endfunction

NeoBundle 'Shougo/vimproc', {
            \ 'build' : {
            \     'windows' : 'make -f make_mingw32.mak',
            \     'cygwin' : 'make -f make_cygwin.mak',
            \     'mac' : 'make -f make_mac.mak',
            \     'unix' : 'make -f make_unix.mak',
            \    },
            \ }

" NeoComplete requires vim to be compiled with lua support
if has('lua')
    NeoBundle 'Shougo/neocomplete.vim'
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#sources#syntax#min_keyword_length = 3

    let g:neocomplete#sources#dictionary#dictionaries = { 'default' : '' }
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif

    " Allow only words to be in the keyword
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Maps <TAB> as <C-n> for completion
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
endif

NeoBundleLazy 'plasticboy/vim-markdown'
    autocmd FileType mkd NeoBundleSource vim-markdown
    let g:vim_markdown_folding_disabled=1

NeoBundleLazy 'scrooloose/syntastic'
    autocmd FileType c,cpp,java,python,lua,html,css NeoBundleSource syntastic

NeoBundleLazy 'rmartinho/vim-cpp11'
    autocmd FileType c,cpp NeoBundleSource vim-cpp11

NeoBundle 'Raimondi/delimitMate'
    autocmd FileType vim let b:loaded_delimitMate = 1

NeoBundle 'godlygeek/tabular'
NeoBundle 'jnurmine/Zenburn'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tomtom/tcomment_vim'

" Check Bundles
NeoBundleCheck

" ----------------------------------
"
"
"         Personal Settings
"
"
" ----------------------------------

filetype plugin indent on
syntax on

set encoding=utf-8

" Remap leader key from default backslash(\) to spacebar
let mapleader=" "

" Disable sounds
set noerrorbells
set novisualbell
set t_vb=

" Improves redrawing
set ttyfast

" Don't update screen while executing a macro, register or
" other commands that not have been typed
set lazyredraw

" Mouse
set mouse=a   " Enable Mouse
set mousehide " Hide mouse when typing

" Allows you to edit other files without saving current file
set hidden

" No backup files
set nobackup
set noswapfile

" Number of command lines to remember
set history=1000

" Allow to use backspace in insert mode
set backspace=indent,eol,start

" Adds line numbers to the left side of the editor
set number

" Adds column numbers to the bottom right of the editor
set ruler

" Highlight the line you are on
set cursorline

" Insert spaces instead of tabs
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
autocmd FileType html,css setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

" Rewrap lines to the 120th column
set textwidth=120

" Add a visual vertical line 1 column after textwidth
if exists('+colorcolumn')
    set colorcolumn=+1
endif

" Searching
set hlsearch   " Highlight search terms
set incsearch  " Show search matches as you type
set ignorecase " Case-Insensitive when searching
set smartcase  " Except if there's a capital letter

" Time it takes to update gui while not doing anything (milliseconds)
set updatetime=500

" Fixes delay after pressing ESC and then O
set timeout timeoutlen=1000 ttimeoutlen=100

" Fixes lag/delay when inserting parentheses and brackets in large files
let g:matchparen_insert_timeout=5

" Color Scheme
colorscheme zenburn

" No toolbar, menu bar, and scroll bar in GVim
if has('gui_running')
    if has("win16") || has("win32") || has('win64')
        set guifont=Consolas:h9
    else
        set guifont=Consolas\ 9
    endif

    set guioptions-=T
    set guioptions-=l
    set guioptions-=L
    set guioptions-=m
    set guioptions-=M
    set guioptions-=r
    set guioptions-=R
endif

" Enable command-line completion
set wildmenu
set wildignore+=*.swp,*.bak,*.pyc,*.class,*/.git/**/*,*/.hg/**/*,*/.svn/**/*,*/tmp/*,*.so
set wildignorecase
set wildmode=list:full

" Automatically remove trailing whitespace
autocmd FileType c,cpp,java,python,lua,vim autocmd BufWritePre <buffer> :%s/\s\+$//e

" Fuzzy file search (Control + P, from ctrlp plugin)
nnoremap <C-p> :<C-u>Unite -start-insert -buffer-name=files file_mru buffer file file_rec/async<cr>

" Find file with pattern (Leader + (a)ck, or (a)g)
nnoremap <leader>a :<C-u>Unite grep:.<cr>

" Find every file with the pattern on cursor (Leader + (a)ck or (a)g)
nnoremap <leader>A :<C-u>execute 'Unite grep:.::' . expand("<cword>") . ' '<cr>

" Switch buffers fast (Leader + (b)uffer)
nnoremap <leader>b :<C-u>Unite -quick-match buffer<cr>

" Map CTRL + L to clear highlighting and then clear/redraw screen.
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

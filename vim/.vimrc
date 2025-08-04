" Enable syntax highlighting
syntax on

" Set indentation
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

" Show line numbers
set number

" Enable mouse support in all modes
set mouse=a

" Enable searching with highlighting and incremental search
set incsearch
set hlsearch

" Always show the status line
set laststatus=2

" Enable file type detection and plugins
filetype plugin indent on

" Set undo files
set undofile
set undodir=~/.vim/undo

" Enable 24-bit true color
set termguicolors

" A more pleasant color scheme (requires a colorscheme to be installed, e.g., gruvbox)
" colorscheme gruvbox

" Map jk to escape in insert mode (faster than pressing Esc)
inoremap jk <Esc>

" Quicker saving and quitting
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :wq<CR>

" Navigate panes more easily
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Enable searching for case-insensitive matches unless uppercase letters are used
set ignorecase
set smartcase

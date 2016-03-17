runtime vendor/vim-plug/plug.vim

syntax on
filetype plugin indent on
set background=dark
set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab
set tabstop=4
set shiftwidth=4
set expandtab
set encoding=utf-8
set relativenumber

call plug#begin('vendor/')
Plug 'tpope/vim-fugitive'
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'neovimhaskell/neovim-ghcmod', { 'for': 'haskell' }
Plug 'feuerbach/vim-hs-module-name', { 'for': 'haskell' }
call plug#end()

" don't install keybinding for hs-module-name
let g:hs_module_no_mappings = 1

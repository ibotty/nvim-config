runtime vim-plug/plug.vim

call plug#begin('~/.config/nvim/vendor/')
Plug 'tpope/vim-fugitive'
Plug 'altercation/vim-colors-solarized'
Plug 'benekastah/neomake'
Plug 'Shougo/deoplete.nvim'
Plug 'ervandew/supertab'
Plug 'tpope/vim-commentary'
Plug 'Raimondi/delimitMate'
Plug 'neovimhaskell/haskell-vim', { 'for': ['haskell', 'cabal'] }

" does not work yet with neovim
"Plug 'eagletmt/ghcmod-vim', { 'for': 'haskell' }
"Plug 'Shougo/vimproc' " only dependency of ghcmod-vim

Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }
Plug 'feuerbach/vim-hs-module-name', { 'for': 'haskell' }
call plug#end()

syntax on
filetype plugin indent on

" color scheme
let g:solarized_visibility='low'
set background=dark
colorscheme solarized

set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab
set tabstop=4
set shiftwidth=4
set expandtab
set encoding=utf-8
set relativenumber

" don't globally install keybinding for hs-module-name
let g:hs_module_no_mappings = 1
function! s:auBindingsHaskellModName()
    nmap <buffer> <silent> <Leader>hM :InsertHaskellModuleName<CR>
endfunction
command! BindingsHaskellModName call <SID>auBindingsHaskellModName()
au BufNewFile,BufRead,WinEnter *.hs,*.lhs   :BindingsHaskellModName

" Disable haskell-vim omnifunc and enable necoghc
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

let g:necoghc_enable_detailed_browse = 1

" binary files
augroup Binary
    au!
    au BufReadPre  *.bin *.fp5 let &bin=1
    au BufReadPost *.bin *.fp5 if &bin | %!xxd
    au BufReadPost *.bin *.fp5 set ft=xxd | endif
    au BufWritePre *.bin *.fp5 if &bin | %!xxd -r
    au BufWritePre *.bin *.fp5 endif
    au BufWritePost *.bin *.fp5 if &bin | %!xxd
    au BufWritePost *.bin *.fp5 set nomod | endif
augroup END

" tab completion like in shell
" ignore some filetypes
if has ("wildmenu")
    set wildmenu
    set wildmode=longest,list
    set wildignore+=*.a,*.o,*~,.git,*.swp,*.tmp
endif

" have at least N lines of context before and below the cursor
set scrolloff=5

" ~ as operator: swap case for motion
set tildeop

" backspace in insert mode works before beginning of insert
set backspace=indent,eol,start

" selecting in virtual block mode treats lines with less columns badly
set virtualedit=block

" search for visual selected text using * and #
" default: visual select till last searchterm
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" fugitive customization
" delete old buffers when jumping to new one
autocmd BufReadPost fugitive://* set bufhidden=delete
" add branchname to statusline
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" persistent undo
set undofile

" automatically wrap, when wrapping is enabled
set formatoptions+=cn1jq

" search case insensitive for lowercase regex, sensitive otherwise
set ignorecase
set smartcase

autocmd! BufWritePost * Neomake
let g:deoplete#enable_at_startup=1

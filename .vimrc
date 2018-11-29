call plug#begin('~/.vim/plugged')

Plug 'Shougo/unite.vim'
Plug 'Shougo/vimproc.vim'
Plug 'bling/vim-airline'
"Plug 'davidhalter/jedi-vim'
Plug 'ervandew/supertab'
Plug 'fatih/vim-go'
Plug 'gmarik/vundle'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'

call plug#end()

set nocompatible
set expandtab
set hlsearch
set incsearch
set laststatus=2
set tabstop=4
set shiftwidth=4
set number
set ignorecase
set background=light
set modeline
set modelines=5
" allows for filename autocompletion when path starts after '=' sign, e.g.
" when assigning a path to a variable in bash script
set isfname-==

" let g:clang_use_library = 1

filetype plugin indent on
syntax enable

" disable docstring jedi-vim autocomplete
autocmd FileType python setlocal completeopt-=preview
autocmd BufNewFile,BufRead *.scala setlocal ft=scala
autocmd FileType scala setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

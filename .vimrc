set runtimepath+=~/.vim/bundle/vundle
call vundle#rc()

Plugin 'Shougo/unite.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'bling/vim-airline'
Plugin 'davidhalter/jedi-vim'
Plugin 'ervandew/supertab'
Plugin 'fatih/vim-go'
Plugin 'gmarik/vundle'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'

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

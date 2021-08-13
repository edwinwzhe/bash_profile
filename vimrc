"""""""""""""""""""""""""""""""""
" Vundle
"""""""""""""""""""""""""""""""""
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
"Plugin 'Valloric/YouCompleteMe'
"Plugin 'scrooloose/NERDTree'
"Plugin 'https://github.com/jistr/vim-nerdtree-tabs.git'
"Plugin 'https://github.com/davidhalter/jedi-vim.git'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Basic settings
filetype on
filetype plugin indent on
syntax on
set number
set ts=4
let mapleader=","


" Color Scheme
" INSTALL:
" $ mkdir -p ~/.vim/colors && cd ~/.vim/colors
" $ wget -O wombat256mod.vim http://www.vim.org/scripts/download_script.php?src_id=13400

set t_Co=256
color wombat256mod

 
" Color column
set colorcolumn=90
highlight ColorColumn ctermbg=233

" Jedi
let g:jedi#popup_on_dot = 1
let g:jedi#completions_command = "<Tab>"

" Disable call signature
let g:jedi#show_call_signatures = 0
" let g:jedi#show_call_signatures_delay = 1000

autocmd FileType python nnoremap <buffer> <F9> :exec '!clear; python3 -i' shellescape(@%, 1)<cr>
autocmd FileType python nnoremap <buffer> <F10> :exec '!clear; python3' shellescape(@%, 1)<cr>

" NERDTree Auto Startup
autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Statusline hightlight
au InsertEnter * hi StatusLine ctermfg=Black ctermbg=LightGreen cterm=NONE
au InsertLeave * hi StatusLine ctermfg=White ctermbg=Blue cterm=NONE
hi StatusLineNC ctermfg=Blue ctermbg=White cterm=NONE

" Customize cursor
" let &t_ti = "\e[1 q"
" let &t_SI = "\e[5 q"
" let &t_EI = "\e[1 q"
" let &t_te = "\e[0 q"

" NERDTree
" let NERDTreeIgnore=['__pycache__', '\.pyc$']

" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" Copy and Paste
set pastetoggle=<F2>
set clipboard=unnamed

" Moving code blocks
vnoremap < <gv
vnoremap > >gv

" Tab
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4
set autoindent
"smarttab


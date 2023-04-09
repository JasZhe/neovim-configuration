" more info found doing :options

set mouse=a
set autoindent
set termguicolors

" better <Leader> key, need to map space to nop otherwise space will move
" cursor forward one position which is annoying
nnoremap <SPACE> <Nop>
let mapleader=" "
let maplocalleader=","

" Fix yank and paste replacing yank register with whatever was replaced
xnoremap p pgvy

set path=$PWD/**

" Change tabs to spaces
set tabstop=2
set shiftwidth=2
set expandtab

" I don't like word wrap lol
set nowrap

" number of screen lines to show around the cursor
set so=3
" highlight the screen line of the cursor
set cul

" set filetype on: vim will try and recognize the type of the file
" plugin on: when a file is edited, its plugin file is loaded. Loads 'ftplugin.vim'
" indent on: when a file is edited, its indent file is loaded. Loads 'indent.vim'
filetype plugin indent on

" Go to next camel case
nnoremap <c-k> :<c-u>call search('\u')<cr>

" move selected lines up one line
xnoremap <C-I>  :m-2<CR>gv=gv

" move selected lines down one line
xnoremap <C-J> :m'>+<CR>gv=gv

" reselect selection after indenting
vnoremap > >gv
vnoremap < <gv

" auto download vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set number "show line numbers on the side

" Use lsp go to definition instead
map <C-]> <Nop>

" NOTE: Map <C-c> to <ESC> in insert mode so we send a leave event so neorg
" parses correctly
" nvm lets just stop using C-c in favour of remapping caps to esc, ctrl-[, jk,
" among others
inoremap <C-c> <Nop>
inoremap jk <Esc>

lua require 'init_lazy'

" wrap the text in the previewer
autocmd User TelescopePreviewerLoaded setlocal wrap

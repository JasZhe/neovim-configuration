set mouse=a
set autoindent
set termguicolors

" better <Leader> key
nnoremap <SPACE> <Nop>
let mapleader=" "

" Fix yank and paste replacing yank register with whatever was replaced
xnoremap p pgvy

set path=$PWD/**

" Change tabs to spaces
set tabstop=2
set shiftwidth=2
set expandtab

" I don't like word wrap lol
set nowrap

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

" Vim-plug Plugins
call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'machakann/vim-highlightedyank'
call plug#end()

if has('ide')
  " mappings and options that exist only in IdeaVim
  map <leader>F <Action>(FindInPath)
  map <leader>G <Action>(FindInPath)
  map <leader>U <Action>(ShowUsages)
  nnoremap <leader>nt :NERDTreeToggle<cr>
else
  nnoremap <leader>nt <cmd>NERDTreeToggle<cr>
endif

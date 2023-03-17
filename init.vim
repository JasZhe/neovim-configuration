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
" NEOVIM GO SETUP FROM ray-x/go.nvim
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " might need to TSUninstall some of the parsers and reinstall
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' } " float term, codeaction and codelens gui support
Plug 'ray-x/go.nvim'

" MINI plugins
Plug 'echasnovski/mini.trailspace', { 'branch': 'stable' }
Plug 'echasnovski/mini.comment', { 'branch': 'stable' }
Plug 'echasnovski/mini.indentscope', { 'branch': 'stable' }
Plug 'echasnovski/mini.completion', { 'branch': 'stable' }
Plug 'echasnovski/mini.map', { 'branch': 'stable' }
Plug 'echasnovski/mini.starter', { 'branch': 'stable' }

" Code navigation
Plug 'ray-x/navigator.lua'

" fun dev icons
Plug 'nvim-tree/nvim-web-devicons'

" Side bar file navigation, NOTE :NeoTreeShowInSplit is really useful
" H to hide or show hidden files
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 's1n7ax/nvim-window-picker' " enables neo-tree to jump to files more easily or something

" Adds git changes, line blames etc
Plug 'lewis6991/gitsigns.nvim'

" Better status bar
Plug 'vim-airline/vim-airline'

" Buffer tabs to behave like other IDEs
Plug 'tiagovla/scope.nvim' " allow scoping of buffers to tabs
Plug 'romgrk/barbar.nvim'

" Autocomplete
Plug 'ms-jpq/coq_nvim', {'branch': 'coq', 'do': ':COQnow'}


" TELESCOPE
Plug 'nvim-lua/plenary.nvim' "required by telescope, some lua coroutines or something
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' } "required by octor, fuzzy finder

" PR reviews and stuff
Plug 'MunifTanjim/nui.nvim' " required by octo, cooler ui components
Plug 'pwntester/octo.nvim' " pr reviews
Plug 'sindrets/diffview.nvim' " better git patch diff view

" MINIMAP
Plug 'gorbit99/codewindow.nvim'

" Symbols outline
Plug 'stevearc/aerial.nvim'

" Mardown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" COLOR SCHEMES
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'navarasu/onedark.nvim'

call plug#end()

" barbar settings
let g:airline#extensions#tabline#enabled = 0 " For barbar buffers to work with airline
let bufferline = get(g:, 'bufferline', {}) " create bufferline option dict
let bufferline.icon_pinned = '車'
let bufferline.icons = 'both'
let bufferline.highlight_inactive_file_icons = v:true

" for barbar keybindings, I want to use the tab navigation for buffer navigation
" instead. Use the :tabn<i> to change tabs. Think of tabs as workspaces
map gt <Nop>
map gT <Nop>

" https://stackoverflow.com/questions/4115841/is-it-possible-to-remap-wq-to-save-and-close-the-current-buffer-instead-of-sav
cnoreabbrev q BufferClose |" Will need to :quit to actually exit the window

colorscheme tokyonight

lua require 'plugins_setup'

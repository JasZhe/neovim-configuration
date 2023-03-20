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
" TREESITTER
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " might need to TSUninstall some of the parsers and reinstall

" fun dev icons
Plug 'nvim-tree/nvim-web-devicons'

" TELESCOPE
Plug 'nvim-lua/plenary.nvim' "required by telescope, some lua coroutines or something
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' } "required by octor, fuzzy finder
Plug 'nvim-telescope/telescope-ui-select.nvim'

" Buffer tabs to behave like other IDEs
Plug 'tiagovla/scope.nvim' " allow scoping of buffers to tabs
Plug 'romgrk/barbar.nvim'

" Side bar file navigation, NOTE :NeoTreeShowInSplit is really useful
" H to hide or show hidden files
Plug 'MunifTanjim/nui.nvim' " required by neo-tree for cooler ui components
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 's1n7ax/nvim-window-picker' " enables neo-tree to choose which pane to open file in

" Debugger
Plug 'mfussenegger/nvim-dap'
Plug 'leoluz/nvim-dap-go'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'

" LSP STUFF
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
" Autocompletion Engine
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
"  Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v1.x'}
" End LSP Zero"
Plug 'glepnir/lspsaga.nvim'


" MINI plugins
Plug 'echasnovski/mini.trailspace', { 'branch': 'stable' }
Plug 'echasnovski/mini.comment', { 'branch': 'stable' }
Plug 'echasnovski/mini.indentscope', { 'branch': 'stable' }
Plug 'echasnovski/mini.map', { 'branch': 'stable' }
Plug 'echasnovski/mini.starter', { 'branch': 'stable' }
Plug 'echasnovski/mini.bracketed'

" VIM session saving
Plug 'tpope/vim-obsession'

" Adds git changes, line blames etc
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'

" Better status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'nvim-lualine/lualine.nvim'

" FUN STUFF
Plug 'tamton-aquib/duck.nvim'
Plug 'eandrju/cellular-automaton.nvim'

" Buffer tabs to behave like other IDEs
Plug 'tiagovla/scope.nvim' " allow scoping of buffers to tabs
Plug 'romgrk/barbar.nvim'

" PR reviews and stuff
Plug 'sindrets/diffview.nvim' " better git patch diff view
Plug 'ldelossa/gh.nvim'
Plug 'ldelossa/litee.nvim'

" Symbols outline
Plug 'stevearc/aerial.nvim'

" Mardown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" Google keep integration
Plug 'stevearc/gkeep.nvim', { 'do': ':UpdateRemotePlugins' }

" COLOR SCHEMES
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'navarasu/onedark.nvim'

" Which key
Plug 'folke/which-key.nvim'

" Leap
Plug 'tpope/vim-repeat'
Plug 'ggandor/leap.nvim'

call plug#end()

" airline stuff
function! s:AirlineSetup()
  let g:airline#extensions#tabline#enabled = 0
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#lsp#enabled = 1
  let g:airline_theme = 'luna'
endfunction

" for barbar keybindings, I want to use the tab navigation for buffer navigation
" instead. Use the :tabn<i> to change tabs. Think of tabs as workspaces
map gt <Nop>
map gT <Nop>
map <C-]> <Nop>

" https://stackoverflow.com/questions/4115841/is-it-possible-to-remap-wq-to-save-and-close-the-current-buffer-instead-of-sav
cnoreabbrev q BufferClose |" Will need to :quit to actually exit the window

colorscheme tokyonight

" call s:AirlineSetup()
lua require 'plugins_setup'

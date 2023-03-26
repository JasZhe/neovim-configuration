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


" TODO: probably gotta switch to a different plugin manager at some point to
" organize these better

" NOTE: Vim-plug Plugins
" call plug#begin('~/.vim/plugged')
" " NOTE: TREESITTER
" Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'} " might need to TSUninstall some of the parsers and reinstall
" Plug 'nvim-treesitter/nvim-treesitter-context'
"
"
" " NOTE: TELESCOPE
" Plug 'nvim-lua/plenary.nvim' "required by telescope, some lua coroutines or something
" Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
" Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' } "required by octor, fuzzy finder
" Plug 'nvim-telescope/telescope-ui-select.nvim'
"
" Plug 'tiagovla/scope.nvim' " allow scoping of buffers to tabs
"
" " TODO: maybe we can try out dirbuf instead of this
" " Side bar file navigation,
" " NOTE :NeoTreeShowInSplit is really useful, H to hide or show hidden files
" Plug 'MunifTanjim/nui.nvim' " required by neo-tree for cooler ui components
" Plug 'nvim-neo-tree/neo-tree.nvim'
" Plug 's1n7ax/nvim-window-picker' " enables neo-tree to choose which pane to open file in
"
"
" " NOTE: Debugger
" Plug 'mfussenegger/nvim-dap'
" Plug 'leoluz/nvim-dap-go'
" Plug 'rcarriga/nvim-dap-ui'
" Plug 'theHamsta/nvim-dap-virtual-text'
"
"
" " NOTE: LSP STUFF
" Plug 'neovim/nvim-lspconfig'
" Plug 'williamboman/mason.nvim'
" Plug 'williamboman/mason-lspconfig.nvim'
" " Autocompletion Engine
" Plug 'hrsh7th/nvim-cmp'
" Plug 'hrsh7th/cmp-nvim-lsp'
" "  Snippets
" Plug 'L3MON4D3/LuaSnip'
" Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v1.x'}
" Plug 'windwp/nvim-autopairs'
"
" Plug 'glepnir/lspsaga.nvim'
" " better diagnostic ui
" Plug 'folke/trouble.nvim'
" Plug 'rcarriga/nvim-notify'
" Plug 'folke/noice.nvim'
" Plug 'jose-elias-alvarez/null-ls.nvim'
"
"
" " NOTE: QOL stuff
" " MINI plugins
" Plug 'echasnovski/mini.trailspace', { 'branch': 'stable' }
" Plug 'echasnovski/mini.comment', { 'branch': 'stable' }
" Plug 'echasnovski/mini.indentscope', { 'branch': 'stable' }
" Plug 'echasnovski/mini.map', { 'branch': 'stable' }
" Plug 'echasnovski/mini.starter', { 'branch': 'stable' }
" Plug 'echasnovski/mini.bracketed'
" " more indent lines
" Plug 'lukas-reineke/indent-blankline.nvim'
" Plug 'folke/todo-comments.nvim'
" Plug 'karb94/neoscroll.nvim'
" Plug 'chrisbra/csv.vim'
"
"
" " NOTE: Git stuff
" " Adds git changes, line blames etc
" Plug 'lewis6991/gitsigns.nvim'
" Plug 'tpope/vim-fugitive'
" " PR reviews and stuff
" Plug 'sindrets/diffview.nvim' " better git patch diff view
" Plug 'ldelossa/gh.nvim'
" Plug 'ldelossa/litee.nvim'
" Plug 'rhysd/committia.vim' " better git commit window in terminal
"
"
" " NOTE: Better status bar
" Plug 'nvim-lualine/lualine.nvim'
"
"
" " NOTE: FUN STUFF
" Plug 'tamton-aquib/duck.nvim'
" Plug 'eandrju/cellular-automaton.nvim'
" Plug 'danilamihailov/beacon.nvim'
" " fun dev icons
" Plug 'nvim-tree/nvim-web-devicons'
"
"
" " Mardown
" Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" " REST Client
" Plug 'rest-nvim/rest.nvim'
"
"
" " Better quick fix
" Plug 'kevinhwang91/nvim-bqf'
"
"
" " COLOR SCHEMES
" Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
" Plug 'navarasu/onedark.nvim'
"
"
" " Which key
" Plug 'folke/which-key.nvim'
"
"
" " Leap
" Plug 'tpope/vim-repeat'
" Plug 'ggandor/leap.nvim'
"
"
" " Focus plugins
" Plug 'folke/twilight.nvim'
" Plug 'folke/zen-mode.nvim'
"
"
" " NEORG
" Plug 'nvim-neorg/neorg', { 'do': ':Neorg sync-parsers' }
"
" " Diagrams
" Plug 'jbyuki/venn.nvim'
"
" call plug#end()

" Use lsp go to definition instead
map <C-]> <Nop>

" NOTE: Map <C-c> to <ESC> in insert mode so we send a leave event so neorg
" parses correctly
inoremap <C-c> <ESC>

" colorscheme tokyonight

lua require 'init_lazy'
lua require 'plugins_setup'

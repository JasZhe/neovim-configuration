
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lsp_lines").setup()

-- require("lazy").setup({
--   -- NOTE: TREESITTER
--   -- on new install I found that I had to uninstall and reinstall some parsers
--   { 'nvim-treesitter/nvim-treesitter', build = ":TSUpdate" },
--   'nvim-treesitter/nvim-treesitter-context',
--
--   -- NOTE: TELESCOPE
--   'nvim-lua/plenary.nvim',
--   { 'nvim-telescope/telescope-fzf-native.nvim', build = "make"},
--   { 'nvim-telescope/telescope.nvim', tag = "0.1.1" },
--   'nvim-telescope/telescope-ui-select.nvim',
--   'nvim-telescope/telescope-live-grep-args.nvim',
--
--   'tiagovla/scope.nvim',
--
--   -- NOTE: NEOTREE
--   'MunifTanjim/nui.nvim', -- cooler ui components for neo-tree
--   'nvim-neo-tree/neo-tree.nvim',
--   's1n7ax/nvim-window-picker', -- enables neotree to pick which pane to open file in
--   'sidebar-nvim/sidebar.nvim', -- sidebar
--
--   -- NOTE: DEBUGGING
--   'mfussenegger/nvim-dap',
--   'leoluz/nvim-dap-go',
--   'rcarriga/nvim-dap-ui',
--   'theHamsta/nvim-dap-virtual-text',
--
--   -- NOTE: LSP STUFF
--   'neovim/nvim-lspconfig',
--   'williamboman/mason.nvim',
--   'williamboman/mason-lspconfig.nvim',
--   -- Autocompletion Engine
--   'hrsh7th/nvim-cmp',
--   'hrsh7th/cmp-nvim-lsp',
--   -- Snippets
--   'L3MON4D3/LuaSnip',
--   { 'VonHeikemen/lsp-zero.nvim', branch = "v1.x" },
--   'windwp/nvim-autopairs',
--
--   'glepnir/lspsaga.nvim',
--   'folke/trouble.nvim', -- better diagnostic ui
--   'rcarriga/nvim-notify',
--   'folke/noice.nvim',
--   'jose-elias-alvarez/null-ls.nvim',
--
--   -- NOTE: QOL Stuff
--   { 'echasnovski/mini.trailspace', branch = "stable" },
--   { 'echasnovski/mini.comment', branch = "stable" },
--   { 'echasnovski/mini.indentscope', branch = "stable" },
--   { 'echasnovski/mini.map', branch = "stable" },
--   { 'echasnovski/mini.starter', branch = "stable" },
--   'echasnovski/mini.bracketed',
--   'lukas-reineke/indent-blankline.nvim', -- More indent lines
--   'folke/todo-comments.nvim',
--   'karb94/neoscroll.nvim',
--   'chrisbra/csv.vim',
--   'nvim-lualine/lualine.nvim',
--   'chrisbra/Recover.vim',
--   'tpope/vim-surround',
--   { 'airblade/vim-rooter', lazy = false, },
--
--   -- NOTE: Bunch of GIT stuff
--   'lewis6991/gitsigns.nvim',
--   'tpope/vim-fugitive',
--   'sindrets/diffview.nvim',
--   'ldelossa/gh.nvim',
--   'ldelossa/litee.nvim',
--   'rhysd/committia.vim',
--
--
--   -- NOTE: FUN STUFF
--   'tamton-aquib/duck.nvim',
--   'eandrju/cellular-automaton.nvim',
--   'danilamihailov/beacon.nvim',
--   'nvim-tree/nvim-web-devicons',
--
--
--   'rest-nvim/rest.nvim', -- REST apis
--
--
--   'kevinhwang91/nvim-bqf', -- better quick fix
--
--   {
--     "folke/tokyonight.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--       vim.cmd([[colorscheme tokyonight]])
--     end,
--   },
--
--
--   'folke/which-key.nvim',
--
--
--   'tpope/vim-repeat',
--   'ggandor/leap.nvim',
--
--
--   -- NOTE: for focusing
--   'folke/twilight.nvim',
--   'folke/zen-mode.nvim',
--
--
--   -- NOTE: documents
--   { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
--   { 'nvim-neorg/neorg', build = ":Neorg sync-parsers" },
--   'jbyuki/venn.nvim',
-- })
--
require("lazy").setup("plugins")

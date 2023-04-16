return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme paper]])
    end
  },
  {
    'morhetz/gruvbox',
    -- config = function()
    --   vim.o.background = 'light'
    --   vim.cmd.colorscheme("gruvbox")
    -- end
  },
  {
    "catppuccin/nvim",
    config = function()
      require("catppuccin").setup({
        term_colors = true
      })
    end
  },
  {
    "rebelot/kanagawa.nvim"
  },
  {
    "tssm/fairyfloss.vim"
  },
  {
    "yorickpeterse/vim-paper",
    -- config = function()
    --   vim.cmd.colorscheme("paper")
    -- end
  },
  {
    "sainnhe/everforest"
    -- config = function()
    --   vim.cmd.colorscheme("everforest")
    -- end
  },
  {
    'altercation/vim-colors-solarized',
    -- config = function()
    --   vim.o.background = 'light'
    --   vim.cmd.colorscheme("solarized")
    -- end
  },
  "NTBBloodbath/sweetie.nvim",
  {
    "EdenEast/nightfox.nvim",
  }
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true },
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "help",
          "query",
          "go",
          "javascript",
          "python",
          "html",
          "css",
          "markdown",
        },
      }
    end,
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-context',
        main = 'treesitter-context'
      },
    },
  },
}

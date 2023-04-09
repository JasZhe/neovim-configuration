return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = "v2.x",
    dependencies = {
      { 'neovim/nvim-lspconfig' },
      {
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    },
  },
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach", -- hopefully should make it so this loads after lsp-zero
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" }
    },
    config = function()
      require("lspsaga").setup({
        outline = {
          win_width = 50,
          keys = {
            expand_or_jump = "<CR>",
            expand_collapse = "t",
          }
        },
        finder = {
          keys = {
            expand_or_jump = '<CR>',
          }
        },
        lightbulb = {
          enable = false,
          virtual_text = false,
        }
      })
      vim.keymap.set("n", "<C-]>", "<cmd>Lspsaga lsp_finder<CR>", { desc = "lspsaga lsp refs" })
      vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "lspsaga code action" })

      -- Diagnostic jump
      -- You can use <C-o> to jump back to your previous location
      vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "lspsaga diagnostic jump prev" })
      vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "lsgsaga diagnostic jump next" })

      -- Diagnostic jump with filters such as only jumping to an error
      vim.keymap.set("n", "[E", function()
          require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end,
        { desc = "lspsaga jump prev error " }
      )
      vim.keymap.set("n", "]E", function()
          require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
        end,
        { desc = "lspsaga jump next error" })

      -- Toggle outline
      vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>")
    end
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = {},
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup {
        sources = {
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.completion.spell,
          null_ls.builtins.code_actions.gitsigns
        }
      }
    end
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      { 'leoluz/nvim-dap-go' },
      { 'rcarriga/nvim-dap-ui' },
      { 'theHamsta/nvim-dap-virtual-text' },
    }
  },
}

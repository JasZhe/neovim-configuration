return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = "v2.x",
    dependencies = {
      {
        "neovim/nvim-lspconfig",
        dependencies = {
          {
            "SmiteshP/nvim-navbuddy",
            dependencies = {
              "SmiteshP/nvim-navic",
              "MunifTanjim/nui.nvim"
            },
            opts = {
              lsp = { auto_attach = true },
              window = { position = { row = "50%", col = "90%" } }
            },
          }
        },
      },
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
    config = function()
      local lsp = require('lsp-zero').preset({
        name = 'recommended',
      })
      lsp.on_attach(function(_, bufnr)
        vim.keymap.set({ 'n' }, '<leader>nb',
          function()
            require('nvim-navbuddy').open()
          end,
          {
            buffer = bufnr,
            desc = "nav buddy"
          })

        lsp.default_keymaps({ buffer = bufnr })

        vim.keymap.set({ 'n', 'x' }, '<leader>ff',
          function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end,
          {
            buffer = bufnr,
            desc = "lsp format butter"
          })
      end)

      vim.filetype.add({ extension = { gohtml = 'html', gotmpl = 'html' } })
      lsp.configure('html', {
        filetypes = { "html", "gohtml", "gotmpl" }
      })

      lsp.configure('pylsp', {
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = {
                ignore = {},
                maxLineLength = 120
              }
            }
          }
        }
      })

      lsp.nvim_workspace({
        library = vim.api.nvim_get_runtime_file('', true)
      })
      vim.opt.signcolumn = 'yes'
      lsp.setup()

      local cmp = require('cmp')
      cmp.setup({
        mapping = {
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }
      })
    end
  },
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
      vim.keymap.set("n", "<leader>rn", ":IncRename ")
    end,
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
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end
  },
  -- {
  --   'neoclide/coc.nvim', branch = 'release', build = "yarn install --frozen-lockfile"
  -- }
}

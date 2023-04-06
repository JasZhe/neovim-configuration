return {
  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    config = function()
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = false
      })
      vim.keymap.set("n", "<Leader>LL", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
    end
  },

  -- passive indent lines
  { 'lukas-reineke/indent-blankline.nvim' },

  {
    'nvim-lualine/lualine.nvim',
    opts = {
      sections = {
        lualine_a = {
          'mode',
          function()
            local animated = {
              "🥚    ",
              " 🐣   ",
              "  🐥  ",
              "    🐓 ",
              "     🍗",
            }
            return animated[os.date("%S") % #animated + 1]
          end
        },
        lualine_c = {
          {
            'filename',
            file_stats = true,
            path = 2,
          }
        }
      }
    },
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' }
    }
  },

  -- TODO: scopes don't seem to be working?
  { 'tiagovla/scope.nvim' },
  { 'chrisbra/Recover.vim' },
  { 'tpope/vim-surround' },
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
  {
    'airblade/vim-rooter',
    lazy = false,
    init = function()
      vim.g.rooter_buftypes = {''}
    end
  },
  { 'chrisbra/csv.vim' },
  {
    'folke/todo-comments.nvim',
    config = function()
      require('todo-comments').setup()
    end
  },
  {
    'folke/trouble.nvim',
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Trouble Toggle" }
    },
    config = function()
      require("trouble").setup {
        mode = "workspace_diagnostics"
      }
    end
  },
  {
    'folke/noice.nvim',
    init = function()
      require("noice").setup()
    end,
    dependencies = {
      { "MunifTanjim/nui.nvim" },
      { 'rcarriga/nvim-notify' },
    }
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({
        disable = { filetypes = { "neo-tree" } }
      })
    end,
  },


  { 'tpope/vim-repeat' },
  { 'romainl/vim-cool' }, -- so we don't gotta type :noh all the time to get rid of search highlighting
  {
    'ggandor/leap.nvim',
    config = function()
      require('leap').add_default_mappings()
    end
  },


  { 'folke/twilight.nvim', main = "twilight" },
  {
    'folke/zen-mode.nvim',
    config = function()
      require("zen-mode").setup({
        window = {
          width = 140
        }
      })
      vim.keymap.set("n", "<leader>ZM", "<cmd>ZenMode<CR>")
    end
  },

  {
    'stevearc/oil.nvim',
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    config = function()
      require('oil').setup()
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cond = false,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-tree/nvim-web-devicons" }, -- not strictly required, but recommended
      { "MunifTanjim/nui.nvim" },
      {
        's1n7ax/nvim-window-picker',
        tag = "v1.*",
        config = function()
          require 'window-picker'.setup({
            autoselect_one = true,
            include_current = false,
            filter_rules = {
              bo = {
                filetype = { 'neo-tree', "neo-tree-popup", "notify" },
                buftype = { 'terminal', "quickfix" },
              },
            },
            other_win_hl_color = '#e35e4f',
          })
        end,
      }
    },
    keys = {
    },
    config = function()
      vim.fn.sign_define("DiagnosticSignError",
        { text = " ", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DiagnosticSignWarn",
        { text = " ", texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DiagnosticSignInfo",
        { text = " ", texthl = "DiagnosticSignInfo" })
      vim.fn.sign_define("DiagnosticSignHint",
        { text = "", texthl = "DiagnosticSignHint" })

      require("neo-tree").setup({
        close_if_last_window = true,
        window = {
          auto_expand_width = true,
          mappings = {
            ["<space>"] = false
          }
        }
      })
    end
  },
  {
    'nvim-tree/nvim-tree.lua',
    keys = {
      { "<leader>/", "<cmd>NvimTreeToggle<cr>", desc = "Toggle nvim-tree" }
    },
    config = function()
      require('nvim-tree').setup({
        view = {
          width = 40,
        },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
        },
        renderer = {
          icons = {
            show = {
              git = false,
              modified = false
            }
          },
          highlight_git = true,
          highlight_modified = 'all'
        }
      })
    end
  }
}

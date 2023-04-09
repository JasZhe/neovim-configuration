return {
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

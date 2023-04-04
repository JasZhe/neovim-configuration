function _G.Toggle_venn()
  local venn_enabled = vim.inspect(vim.b.venn_enabled)
  if venn_enabled == "nil" then
    vim.b.venn_enabled = true
    vim.cmd [[setlocal ve=all]]
    -- draw a line on HJKL keystokes
    vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
    vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
    vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
    vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
    -- draw a box by pressing "f" with visual selection
    vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
  else
    vim.cmd [[setlocal ve=]]
    vim.cmd [[mapclear <buffer>]]
    vim.b.venn_enabled = nil
  end
end

return {
  { 'echasnovski/mini.comment',   version = false, config = function() require('mini.comment').setup() end },   -- easy commenting
  { 'echasnovski/mini.starter',   version = false, config = function() require('mini.starter').setup() end },
  { 'echasnovski/mini.bracketed', version = false, config = function() require('mini.bracketed').setup() end }, -- scope navigation
  {
    'echasnovski/mini.trailspace',
    version = false,
    config = function()
      local mini_trailspace = require('mini.trailspace')
      mini_trailspace.setup()
      vim.keymap.set('n', '<leader>ts', function() mini_trailspace.trim() end)
    end
  },
  { 'echasnovski/mini.indentscope',       version = false, config = function() require('mini.indentscope').setup() end }, -- dynamic indent scope highlight
  {
    'echasnovski/mini.map',
    version = false,
    config = function()
      local minimap = require('mini.map')
      minimap.setup({
        integrations = {
          minimap.gen_integration.builtin_search(),
          minimap.gen_integration.gitsigns(),
          minimap.gen_integration.diagnostic(),
        },
        symbols = {
          encode = minimap.gen_encode_symbols.dot('4x2'),
        },
        window = {
          focusable = true,
          show_integration_count = true,
          width = 15
        }
      })
      vim.keymap.set('n', '<leader>mm', function() minimap.toggle() end)
      vim.keymap.set('n', '<leader>mf', function() minimap.toggle_focus() end)
    end
  },

  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    config = function()
      vim.diagnostic.config({
        virtual_text = false,
      })
      vim.keymap.set("n", "<Leader>LL", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
    end
  },

  -- passive indent lines
  { 'lukas-reineke/indent-blankline.nvim' },

  {
    "cbochs/grapple.nvim",
    config = function()
      vim.keymap.set("n", "<leader>gt", require("grapple").toggle)

      local grapple_hooks = function()
        local grapple = require("grapple")
        local tags = grapple.tags()
        local results_list = {}

        for _, tag in ipairs(tags) do
          local filepath = tag.file_path
          local row, col = unpack(tag.cursor)
          table.insert(
            results_list,
            { filepath, row, col }
          )
        end

        local default_options = {
          sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
          previewer = require("telescope.config").values.grep_previewer {},
          results_title = "Grapple Hooks",
          prompt_title = "Grapple Hooks",
          layout_strategy = "flex",
        }

        require("telescope.pickers")
            .new({
              finder = require("telescope.finders").new_table({
                results = results_list,
                entry_maker = function(entry)
                  return {
                    value = entry,
                    filename = entry[1],
                    display = entry[1],
                    ordinal = entry[1],
                    lnum = entry[2]
                  }
                end
              }),
            }, default_options):find()
      end

      vim.keymap.set("n", "<Leader>M", grapple_hooks, {})
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },

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
  { 'airblade/vim-rooter', lazy = false, },
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
        mode = "document_diagnostics"
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
      require("which-key").setup({})
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


  { 'folke/twilight.nvim',   main = "twilight" },
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


  { "ellisonleao/glow.nvim", config = true,    cmd = "Glow" },
  {
    'nvim-neorg/neorg',
    build = ":Neorg sync-parsers",
    init = function()
      require('neorg').setup {
        load = {
          ["core.defaults"] = {},       -- Loads default behaviour
          ["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
          ["core.integrations.treesitter"] = {},
          ["core.export"] = {},
          ["core.norg.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                notes = "~/notes/notes",
                meetings = "~/notes/meetings",
                interviews = "~/notes/interviews",
              },
            },
          },
        },
      }
    end
  },
  {
    'jbyuki/venn.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>V', ":lua Toggle_venn()<CR>", { noremap = true })
    end
  },
}

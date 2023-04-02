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

  -- passive indent lines
  { 'lukas-reineke/indent-blankline.nvim' },

  {
    'sidebar-nvim/sidebar.nvim',
    init = function()
      local utils = require("sidebar-nvim.utils")
      local Loclist = require("sidebar-nvim.components.loclist")
      local config = require("sidebar-nvim.config")
      local has_devicons, devicons = pcall(require, "nvim-web-devicons")

      local loclist = Loclist:new({ omit_single_group = true })
      local function get_fileicon(filename)
        if has_devicons and devicons.has_loaded() then
          local extension = filename:match("^.+%.(.+)$")

          local fileicon = ""
          local icon, highlight = devicons.get_icon(filename, extension)
          if icon then
            fileicon = icon
          end

          if not highlight then
            highlight = "SidebarNvimNormal"
          end

          return {
            text = "  " .. fileicon .. " ",
            hl = highlight,
          }
        else
          return { text = "   " }
        end
      end

      local function get_grapple_hooks(ctx)
        local loclist_items = {}

        local lines = {}
        local hl = {}
        local grapple = require("grapple")

        local tags = grapple.tags()
        local current_buffer_path = vim.api.nvim_buf_get_name(0)

        for _, tag in ipairs(tags) do
          local ignore = false

          local name_hl = "SidebarNvimNormal"
          local file_path = tag.file_path
          if file_path == current_buffer_path then
            name_hl = "SidebarNvimBuffersActive"
          end

          for idx, loc in ipairs(loclist_items) do
            if loc.data.filepath == file_path then
              ignore = true
              break
            end
          end

          if not ignore then
            loclist_items[#loclist_items + 1] = {
              group = "grapples",
              left = {
                get_fileicon(file_path),
                { text = utils.filename(file_path), hl = name_hl },
              },
              data = { filepath = file_path },
            }
          end
        end

        loclist:set_items(loclist_items, { remove_groups = false })
        loclist:draw(ctx, lines, hl)

        if lines == nil or #lines == 0 then
          return "<no grapples>"
        else
          return { lines = lines, hl = hl }
        end
      end

      local grapple_hooks = {
        title = "Grapple Hooks",
        icon = config["buffers"].icon,
        draw = function(ctx)
          return get_grapple_hooks(ctx)
        end,
        highlights = {
          groups = {},
          links = {
            SidebarNvimBuffersActive = "SidebarNvimSectionTitle",
            SidebarNvimBuffersNumber = "SIdebarnvimLineNr",
          },
        },
        bindings = {
          ["d"] = function(line)
            local grapple = require("grapple")
            local location = loclist:get_location_at(line)

            if location == nil then
              return
            end

            grapple.untag({ file_path = location.data.filepath })
          end,
          ["e"] = function(line)
            local location = loclist:get_location_at(line)
            if location == nil then
              return
            end

            vim.cmd("wincmd p")
            vim.cmd("e " .. location.data.filepath)
          end,
        },
      }

      local sidebar = require("sidebar-nvim")
      sidebar.setup({
        sections = { grapple_hooks, "buffers", "todos", "git", "diagnostics", "files", "symbols" },
        update_interval = 500,
      })
      vim.keymap.set("n", "<leader>sb", "<cmd>SidebarNvimToggle<cr>")
    end
  },

  {
    "cbochs/grapple.nvim",
    config = function ()
      vim.keymap.set("n", "<leader>gt", require("grapple").toggle)
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

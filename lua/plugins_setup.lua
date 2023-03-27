local vim = vim
local keymap = vim.keymap.set

function MiniSetup()
  require('mini.bracketed').setup()
  require('mini.comment').setup()
  require('mini.indentscope').setup()
  require('mini.starter').setup()
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
  keymap('n', '<leader>mm', function() minimap.toggle() end)
  keymap('n', '<leader>mf', function() minimap.toggle_focus() end)

  local mini_trailspace = require('mini.trailspace')
  mini_trailspace.setup()
  keymap('n', '<leader>ts', function() mini_trailspace.trim() end)
end

function ScopeSetup()
  require('scope').setup() -- without this, buffers in other tabs will show up
end

function TelescopeSetup()
  keymap('n', '<leader>F', '<cmd>Telescope find_files<cr>')
  keymap('n', '<leader>U', '<cmd>Telescope lsp_references<cr>')
  keymap('n', '<leader>B', '<cmd>Telescope buffers<cr>')
  keymap('n', '<leader>th', '<cmd>Telescope help_tags<cr>')
  require("telescope").load_extension("ui-select")

  function vim.getVisualSelection()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    vim.fn.setreg('v', {})

    text = string.gsub(text, "\n", "")
    if #text > 0 then
      return text
    else
      return ''
    end
  end

  -- NOTE: this portion allows us to visual select and then fuzzy find the selection
  local tb = require('telescope.builtin')
  local opts = { noremap = true, silent = true }

  keymap('n', '<space>gb', ':Telescope current_buffer_fuzzy_find<cr>', opts)
  keymap('v', '<space>gb', function()
    local text = vim.getVisualSelection()
    tb.current_buffer_fuzzy_find({ default_text = text })
  end, opts)

  keymap('n', '<space>G', ':Telescope live_grep<cr>', opts)
  keymap('v', '<space>G', function()
    local text = vim.getVisualSelection()
    tb.live_grep({ default_text = text })
  end, opts)

  -- stole this off of https://www.petergundel.de/git/neovim/telescope/2023/03/22/git-jump-in-neovim-with-telescope.html
  local git_hunks = function()
    require("telescope.pickers")
      .new({
        finder = require("telescope.finders").new_oneshot_job({ "git", "jump", "--stdout", "diff" }, {
          entry_maker = function(line)
            local filename, lnum_string = line:match("([^:]+):(%d+).*")

            -- I couldn't find a way to use grep in new_oneshot_job so we have to filter here.
            -- return nil if filename is /dev/null because this means the file was deleted.
            if filename:match("^/dev/null") then
              return nil
            end

            return {
              value = filename,
              display = line,
              ordinal = line,
              filename = filename,
              lnum = tonumber(lnum_string),
            }
          end,
        }),
        sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
        previewer = require("telescope.config").values.grep_previewer({}),
        results_title = "Git hunks",
        prompt_title = "Git hunks",
        layout_strategy = "flex",
      }, {})
      :find()
  end

  vim.keymap.set("n", "<Leader>gh", git_hunks, {})

end

function LspServers()
  local lsp = require('lsp-zero').preset({
    name = 'recommended',
    set_lsp_keymaps = true,
    manage_nvim_cmp = true,
    suggest_lsp_servers = false,
  })
  lsp.setup_nvim_cmp({
    preselect = 'none',
    completion = {
      completeopt = 'menu,menuone,noinsert,noselect'
    }
  })
  vim.filetype.add({ extension = { gohtml = 'html', gotmpl = 'html' } })
  lsp.configure('html', {
    filetypes = { "html", "gohtml", "gotmpl" }
  })

  keymap("n", "<leader>ff", "<cmd>LspZeroFormat<CR>")
  lsp.nvim_workspace({
    library = vim.api.nvim_get_runtime_file('', true)
  })
  vim.opt.signcolumn = 'yes'
  lsp.setup()

  local null_ls = require("null-ls")
  null_ls.setup {
    sources = {
      null_ls.builtins.formatting.goimports,
      null_ls.builtins.completion.spell,
      null_ls.builtins.code_actions.gitsigns
    }
  }

  -- NOTE: auto pairs setup
  require("nvim-autopairs").setup {}
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  local cmp = require('cmp')
  cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
  )
end

function LspSagaSetup()
  require("lspsaga").setup({
    outline = {
      keys = {
        jump = "<CR>"
      },
      auto_close = true
    }
  })
  keymap("n", "<C-]>", "<cmd>Lspsaga lsp_finder<CR>")
  keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>")
  keymap("n", "gr", "<cmd>Lspsaga rename<CR>")
  keymap("n", "gR", "<cmd>Lspsaga rename ++project<CR>")
  keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>")

  -- Show buffer diagnostics
  keymap("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")

  -- Diagnostic jump
  -- You can use <C-o> to jump back to your previous location
  keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
  keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")

  -- Diagnostic jump with filters such as only jumping to an error
  keymap("n", "[E", function()
    require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end)
  keymap("n", "]E", function()
    require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
  end)

  -- Toggle outline
  keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>")
end

function TreeSitterSetup()
  require 'nvim-treesitter.configs'.setup({
    highlight = { enable = true }
  })
  require 'treesitter-context'.setup {}
end

function Github()
  require('litee.lib').setup()
  require('litee.gh').setup({ icon_set = "nerd" })
end

-- TODO have some of these functions return mappings that we can pass into whichkey, so we can have a central place for the keybindings

function WhichKey()
  vim.o.timeout = true
  vim.o.timeoutlen = 300
  local whichkey = require('which-key')
  whichkey.setup({
    disable = { buftypes = { "neo-tree" }, filetypes = { "neo-tree" } }
  })
end

function GitSignsSetup()
  require('gitsigns').setup({
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        keymap(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      map('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      -- Actions
      map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
      map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
      map('n', '<leader>nh', gs.next_hunk)
      map('n', '<leader>ph', gs.prev_hunk)
      map('n', '<leader>hu', gs.undo_stage_hunk)
      map('n', '<leader>hp', gs.preview_hunk)
      map('n', '<leader>hb', function() gs.blame_line { full = true } end)
      map('n', '<leader>hd', function() gs.diffthis("HEAD", { split = "rightbelow" }) end)
      map('n', '<leader>hD', function() gs.diffthis('~', { split = "rightbelow" }) end)

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end,
    current_line_blame = true,
    current_line_blame_opts = { delay = 500 },
    numhl = true,
    word_diff = true,
    debug_mode = true,
    diff_opts = {
      internal = true
    },
  })
end

function LuaLineSetup()
  local lualine = require('lualine')
  lualine.setup {
    extensions = { 'aerial', 'neo-tree', 'toggleterm' },
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
  }
end

function FunStuff()
  keymap("n", "<leader>fml", "<cmd>CellularAutomaton game_of_life<CR>")
  local duck = require('duck')
  vim.api.nvim_create_user_command('Duck',
    function(opts)
      if (opts.args == 'duck') then
        duck.hatch('🐤')
      elseif (opts.args == 'eggplant') then
        duck.hatch('🍆')
      elseif (opts.args == 'water') then
        duck.hatch('💧')
      elseif (opts.args == 'cook') then
        duck.cook()
      else
        duck.hatch()
      end
    end,
    {
      nargs = 1,
      complete = function(_, _, _) return { 'duck', 'eggplant', 'water', 'cook' } end
    })
  keymap('n', '<leader>dk', function() duck.cook() end, {})
  require('neoscroll').setup()
end

function LeapSetup() require('leap').add_default_mappings() end

function ResetSetup() require("rest-nvim").setup() end

function TwilightSetup()
  require("twilight").setup {}
  require("zen-mode").setup {
    window = {
      width = 140
    }
  }
  keymap("n", "<leader>ZM", "<cmd>ZenMode<CR>")
end

function LspLines()
  vim.diagnostic.config({
    virtual_text = false,
  })
end

function TroubleSetup()
  require("trouble").setup {
    mode = "document_diagnostics"
  }
  vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
    { silent = true, noremap = true }
  )

  require('todo-comments').setup()
end

function Noice() require('noice').setup() end

function NeOrgSetup()
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

function SideBarSetup()
  require("sidebar-nvim").setup({
    sections = { "buffers", "todos", "git", "diagnostics", "files", "symbols" },
    update_interval = 500
  })
  vim.keymap.set("n", "<leader>sb", "<cmd>SidebarNvimToggle<cr>")
end

TreeSitterSetup()
MiniSetup()
ScopeSetup()
TelescopeSetup()
LspServers()
GitSignsSetup()
LspSagaSetup()
LuaLineSetup()
FunStuff()
Github()
WhichKey()
LeapSetup()
ResetSetup()
TwilightSetup()
LspLines()
TroubleSetup()
Noice()
NeOrgSetup()
SideBarSetup()
-- toggle keymappings for venn using <leader>v
vim.api.nvim_set_keymap('n', '<leader>V', ":lua Toggle_venn()<CR>", { noremap = true })

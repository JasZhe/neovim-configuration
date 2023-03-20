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

function MiniMapSetup()
  vim.g.minimap_width = 15
  vim.g.minimap_auto_start = 1
  vim.g.minimap_auto_start_win_enter = 0
  vim.g.minimap_left = 0
  vim.g.minimap_block_filetypes = { 'fugitive', 'nvim-tree', 'tagbar', 'fzf', 'telescope', 'NvimTree', 'NeoTree' }
  vim.g.minimap_block_buftypes = { 'nofile', 'nowrite', 'quickfix', 'terminal', 'prompt', 'NvimTree', 'NeoTree' }
  vim.g.minimap_close_filetypes = { 'startify', 'netrw', 'vim-plug', 'NvimTree', 'NeoTree' }
  vim.g.minimap_highlight_range = 1
  vim.g.minimap_highlight_search = 1
  vim.g.minimap_git_colors = 1

  vim.keymap.set('n', 'mm', '<cmd>MinimapToggle<CR>')
end

function BarbarSetup()
  require('scope').setup() -- without this, buffers in other tabs will show up

  -- barbar offset with filetree plugins so buffer tab lines up with window
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(tbl)
      local set_offset = require('bufferline.api').set_offset

      local bufwinid
      local last_width
      local autocmd = vim.api.nvim_create_autocmd('WinScrolled', {
        callback = function()
          bufwinid = bufwinid or vim.fn.bufwinid(tbl.buf)

          local width = vim.api.nvim_win_get_width(bufwinid)
          if width ~= last_width then
            set_offset(width, 'FileTree')
            last_width = width
          end
        end,
      })

      vim.api.nvim_create_autocmd('BufWipeout', {
        buffer = tbl.buf,
        callback = function()
          vim.api.nvim_del_autocmd(autocmd)
          set_offset(0)
        end,
        once = true,
      })
    end,
    pattern = 'neo-tree'
  })

  require 'bufferline'.setup {
    icon_pinned = '車',
    icons = 'both',
    highlight_inactive_file_icons = true
  }

  keymap('n', '<leader>p', '<cmd>BufferPin<CR>')
  keymap('n', '<A-p>', '<cmd>BufferPick<CR>')
  keymap('n', '<A-c>', '<cmd>BufferClose<CR>')

  keymap('n', 'gt', '<cmd>BufferNext<CR>')
  keymap('n', 'gT', '<cmd>BufferPrevious<CR>')
  keymap('n', '<A-,>', '<Cmd>BufferPrevious<CR>')
  keymap('n', '<A-.>', '<Cmd>BufferNext<CR>')

  keymap('n', '<A-,>', '<Cmd>BufferPrevious<CR>')
  keymap('n', '<A-.>', '<Cmd>BufferNext<CR>')
  keymap('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>')
  keymap('n', '<A->>', '<Cmd>BufferMoveNext<CR>')

  keymap('n', '<A-1>', '<Cmd>BufferGoto 1<CR>')
  keymap('n', '<A-2>', '<Cmd>BufferGoto 2<CR>')
  keymap('n', '<A-3>', '<Cmd>BufferGoto 3<CR>')
  keymap('n', '<A-2>', '<Cmd>BufferGoto 4<CR>')
  keymap('n', '<A-5>', '<Cmd>BufferGoto 5<CR>')
  keymap('n', '<A-6>', '<Cmd>BufferGoto 6<CR>')
  keymap('n', '<A-7>', '<Cmd>BufferGoto 7<CR>')
  keymap('n', '<A-8>', '<Cmd>BufferGoto 8<CR>')
  keymap('n', '<A-9>', '<Cmd>BufferGoto 9<CR>')
  keymap('n', '<A-0>', '<Cmd>BufferLast<CR>')
end

function AerialSetup()
  local aerial = require("aerial")
  aerial.setup({
    attach_mode = "global",
    close_automatic_events = { 'unsupported', 'unfocus' },
    layout = {
      min_width = { 65, 0.25 },
      default_direction = "left"
    },
    close_on_select = true
  })
  vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle<CR>')
  -- also setup telescope extension
  require('telescope').load_extension('aerial')
  keymap('n', '<leader>A', '<cmd>Telescope aerial<cr>')
end

function TelescopeSetup()
  keymap('n', '<leader>F', '<cmd>Telescope find_files<cr>')
  keymap('n', '<leader>U', '<cmd>Telescope lsp_references<cr>')
  keymap('n', '<leader>G', '<cmd>Telescope live_grep<cr>')
  keymap('n', '<leader>B', '<cmd>Telescope buffers<cr>')
  keymap('n', '<leader>th', '<cmd>Telescope help_tags<cr>')
  require("telescope").load_extension("ui-select")
end

function NeoTreeSetup()
  require('window-picker').setup() -- allows us to choose which pane to open file in
  require 'neo-tree'.setup()
  vim.keymap.set('n', '<leader>nt', '<cmd>NeoTreeShowToggle<cr>')
end

function LspServers()
  local lsp = require('lsp-zero').preset({
    name = 'recommended',
    set_lsp_keymaps = true,
    manage_nvim_cmp = true,
    suggest_lsp_servers = false,
  })
  lsp.setup()
  keymap("n", "<leader>ff", "<cmd>LspZeroFormat<CR>")
  lsp.nvim_workspace({
    library = vim.api.nvim_get_runtime_file('', true)
  })

  require('lsp_lines').setup()
  vim.diagnostic.config({
    virtual_text = false,
  })
  vim.opt.signcolumn = 'yes'
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
  require'treesitter-context'.setup{}
end

function Github()
  require('litee.lib').setup()
  require('litee.gh').setup()
end

-- TODO have some of these functions return mappings that we can pass into whichkey, so we can have a central place for the keybindings

function WhichKey()
  vim.o.timeout = true
  vim.o.timeoutlen = 300
  local whichkey = require('which-key')
  whichkey.setup()
  whichkey.register({
    g = {
      name = "+Git",
      h = {
        -- Probably can get rid of a couple of these
        name = "+Github",
        c = {
          name = "+Commits",
          c = { "<cmd>GHCloseCommit<cr>", "Close" },
          e = { "<cmd>GHExpandCommit<cr>", "Expand" },
          o = { "<cmd>GHOpenToCommit<cr>", "Open To" },
          p = { "<cmd>GHPopOutCommit<cr>", "Pop Out" },
          z = { "<cmd>GHCollapseCommit<cr>", "Collapse" },
        },
        i = {
          name = "+Issues",
          p = { "<cmd>GHPreviewIssue<cr>", "Preview" },
        },
        l = {
          name = "+Litee",
          t = { "<cmd>LTPanel<cr>", "Toggle Panel" },
        },
        r = {
          name = "+Review",
          b = { "<cmd>GHStartReview<cr>", "Begin" },
          c = { "<cmd>GHCloseReview<cr>", "Close" },
          d = { "<cmd>GHDeleteReview<cr>", "Delete" },
          e = { "<cmd>GHExpandReview<cr>", "Expand" },
          s = { "<cmd>GHSubmitReview<cr>", "Submit" },
          z = { "<cmd>GHCollapseReview<cr>", "Collapse" },
        },
        p = {
          name = "+Pull Request",
          c = { "<cmd>GHClosePR<cr>", "Close" },
          d = { "<cmd>GHPRDetails<cr>", "Details" },
          e = { "<cmd>GHExpandPR<cr>", "Expand" },
          o = { "<cmd>GHOpenPR<cr>", "Open" },
          p = { "<cmd>GHPopOutPR<cr>", "PopOut" },
          r = { "<cmd>GHRefreshPR<cr>", "Refresh" },
          t = { "<cmd>GHOpenToPR<cr>", "Open To" },
          z = { "<cmd>GHCollapsePR<cr>", "Collapse" },
        },
        t = {
          name = "+Threads",
          c = { "<cmd>GHCreateThread<cr>", "Create" },
          n = { "<cmd>GHNextThread<cr>", "Next" },
          t = { "<cmd>GHToggleThread<cr>", "Toggle" },
        },
      },
    },
  }, { prefix = "<leader>" })
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
      map('n', '<leader>hS', gs.stage_buffer)
      map('n', '<leader>hu', gs.undo_stage_hunk)
      map('n', '<leader>hR', gs.reset_buffer)
      map('n', '<leader>hp', gs.preview_hunk)
      map('n', '<leader>hb', function() gs.blame_line { full = true } end)
      map('n', '<leader>tb', gs.toggle_current_line_blame)
      map('n', '<leader>hd', gs.diffthis)
      map('n', '<leader>hD', function() gs.diffthis('~') end)
      map('n', '<leader>td', gs.toggle_deleted)

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
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
  require("presence").setup()
end

function LeapSetup()
  require('leap').add_default_mappings()
end

function ResetSetup()
  require("rest-nvim").setup()
end

function TwilightSetup()
  require("twilight").setup {}
  require("zen-mode").setup {
    window = {
      width = 140
    }
  }
  keymap("n", "<leader>ZM", "<cmd>ZenMode<CR>")
end

TreeSitterSetup()
MiniSetup()
BarbarSetup()
TelescopeSetup()
NeoTreeSetup()
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

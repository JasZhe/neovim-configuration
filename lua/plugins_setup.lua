function SetupGo()
  require 'go'.setup({
    goimport = 'gopls', -- if set to 'gopls' will use golsp format
    gofmt = 'gopls',    -- if set to gopls will use golsp format
    max_line_len = 120,
    tag_transform = false,
    test_dir = '',
    comment_placeholder = '   ',
    lsp_cfg = true,       -- false: use your own lspconfig
    lsp_gofumpt = true,   -- true: set default gofmt in gopls format to gofumpt
    lsp_on_attach = true, -- use on_attach from go.nvim
    lsp_keymaps = false,
    dap_debug = true,
  })

  require 'navigator'.setup({
    keymaps = { { key = "<leader>t", func = vim.lsp.buf.type_definition, desc = "prefer gt mapping for tab navigation" } }
  })
end

function MiniSetup()
  require('mini.comment').setup()
  require('mini.indentscope').setup()
  require('mini.completion').setup()
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
      show_integration_count = false,
      width = 15
    }
  })
  vim.keymap.set('n', '<leader>mm', function() minimap.toggle() end)
  vim.keymap.set('n', '<leader>mf', function() minimap.toggle_focus() end)

  local mini_trailspace = require('mini.trailspace')
  mini_trailspace.setup()
  vim.keymap.set('n', '<leader>ts', function() mini_trailspace.trim() end)
end

function BarbarSetup()
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

  vim.keymap.set('n', 'gt', '<cmd>BufferNext<CR>')
  vim.keymap.set('n', 'gT', '<cmd>BufferPrevious<CR>')
  vim.keymap.set('n', '<leader>p', '<cmd>BufferPin<CR>')
end

function CodeWindowSetup()
  local codewindow = require('codewindow')
  codewindow.setup({
    show_cursor = false,
    exclude_filetypes = { "neo-tree", "aerial", "Scratch", "Plugins" }
  })
  vim.keymap.set('n', '<leader>cw', function() codewindow.toggle_minimap() end)
  vim.keymap.set('n', '<leader>cwf', function() codewindow.toggle_focus() end)
end

function AerialSetup()
  require("aerial").setup({
    attach_mode = "global",
    layout = {
      default_direction = "left"
    }
  })
  vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
end

function TelescopeSetup()
  -- also setup telescope extension
  require('telescope').load_extension('aerial')
  vim.keymap.set('n', '<leader>F', '<cmd>Telescope find_files<cr>')
  vim.keymap.set('n', '<leader>U', '<cmd>Telescope lsp_references<cr>end')
  vim.keymap.set('n', '<leader>G', '<cmd>Telescope live_grep<cr>')
  vim.keymap.set('n', '<leader>B', '<cmd>Telescope buffers<cr>')
  vim.keymap.set('n', '<leader>th', '<cmd>Telescope help_tags<cr>')
  vim.keymap.set('n', '<leader>A', '<cmd>Telescope aerial<cr>')
end

function NeoTreeSetup()
  require 'neo-tree'.setup()
  vim.keymap.set('n', '<leader>nt', '<cmd>NeoTreeShowToggle<cr>')
end

function LspServers()
  require 'lspconfig'.vimls.setup {}
  require 'lspconfig'.lua_ls.setup {}
end

function TreeSitterSetup()
  require 'nvim-treesitter.configs'.setup({
    highlight = { enable = true }
  })
end

function ToggleTermSetup()
  require('toggleterm').setup({
    open_mapping = [[c-\]]
  })
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
  vim.cmd('autocmd! TermOpen term://* lua ToggleTermSetup()')
end

function GitSignsSetup()
  require('gitsigns').setup({
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
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

TreeSitterSetup()
SetupGo()
MiniSetup()
BarbarSetup()
AerialSetup()
TelescopeSetup()
NeoTreeSetup()
LspServers()
GitSignsSetup()

require('scope').setup()
require('octo').setup()
require('window-picker').setup()

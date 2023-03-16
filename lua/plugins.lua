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


local protocol = require 'vim.lsp.protocol'
require 'navigator'.setup({
  keymaps = { { key = "<leader>t", func = vim.lsp.buf.type_definition, desc = "prefer gt mapping for tab navigation" } }
})


-- MINI STUFF
require('mini.comment').setup()
require('mini.indentscope').setup()
require('mini.completion').setup()
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
  }
})
vim.keymap.set('n', '<leader>mm', function() minimap.toggle() end)

local mini_trailspace = require('mini.trailspace')
mini_trailspace.setup()
vim.keymap.set('n', '<leader>ts', function() mini_trailspace.trim() end)


-- barbar offset with filetree plugins
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

local codewindow = require('codewindow')
codewindow.setup({
  show_cursor = false,
  exclude_filetypes = { "neo-tree", "aerial", "Scratch", "Plugins" }
})
vim.keymap.set('n', '<leader>cw', function() codewindow.toggle_minimap() end)
vim.keymap.set('n', '<leader>cwf', function() codewindow.toggle_focus() end)


require("aerial").setup({
  attach_mode = "global",
})
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
require('telescope').load_extension('aerial')


require("neo-tree").setup({
  window = {
    width = 40
  }
})

require 'lspconfig'.vimls.setup {}
require 'lspconfig'.lua_ls.setup {}
require 'scope'.setup()
require 'gitsigns'.setup()
require 'octo'.setup()
require 'toggleterm'.setup()
require 'window-picker'.setup()

require 'nvim-treesitter.configs'.setup { highlight = { enable = true } }

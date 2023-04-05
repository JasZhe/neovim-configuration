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
}

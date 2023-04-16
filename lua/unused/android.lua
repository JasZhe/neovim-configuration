
-- require('lspconfig.configs').my_kotlin = {
--   default_config = {
--     name = 'my_kotlin',
--     cmd = { '/Users/jason.z/code/kotlin-language-server/server/build/install/server/bin/kotlin-language-server' },
--     filetypes = {'kotlin', 'kt'},
--     root_dir = require('lspconfig.util').root_pattern({'.git'})
--   }
-- }
--
-- require('lspconfig').my_kotlin.setup({})
return {
  'johngrib/Comrade',
  branch = "fix-nvim",
  dependencies = {
    {
      'Shougo/deoplete.nvim',
      build = ":UpdateRemotePlugins",
    }
  }
}

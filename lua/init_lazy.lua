local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lsp_lines").setup()

require("lazy").setup("plugins")


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

lsp.configure('pylsp', {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {},
          maxLineLength = 120
        }
      }
    }
  }
})

lsp.on_attach(function(_, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
  vim.keymap.set({ 'n', 'x' }, '<leader>ff', function()
    vim.lsp.buf.format({ bufnr = bufnr })
  end, {
    buffer = bufnr,
    desc = "lsp format butter"
  })
end)

lsp.nvim_workspace({
  library = vim.api.nvim_get_runtime_file('', true)
})
vim.opt.signcolumn = 'yes'
lsp.setup()

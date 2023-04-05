
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

vim.api.nvim_create_autocmd('VimEnter', {
	desc = 'Open diffview on commit messages',

	group = vim.api.nvim_create_augroup('open_diffview_on_commit', { clear = true }),
	callback = function (opts)
		if vim.bo[opts.buf].filetype == 'gitcommit' then
			vim.cmd 'DiffviewOpen --staged'
		end
	end,
})

require("lsp_lines").setup()

require("lazy").setup("plugins")

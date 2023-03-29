local keymap = vim.keymap.set
return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
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
        map('n', '<leader>hD', function() gs.diffthis("HEAD", { split = "rightbelow" }) end)

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
    }
  },

  { 'tpope/vim-fugitive' },

  { 'sindrets/diffview.nvim' },

  {
    'ldelossa/gh.nvim',
    main = "litee.gh",
    opts = { icon_set = "nerd" },
    dependencies = {
      { 'ldelossa/litee.nvim', main = "litee.lib" }
    }
  },

  { 'rhysd/committia.vim' },
}

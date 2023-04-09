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
        map('n', '<leader>]h', gs.next_hunk)
        map('n', '<leader>[h', gs.prev_hunk)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function() gs.blame_line { full = true } end)

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end,
      current_line_blame = true,
      current_line_blame_opts = { delay = 500 },
      numhl = true,
      word_diff = false,
      debug_mode = true,
      diff_opts = {
        internal = true
      },
    }
  },

  { 'tpope/vim-fugitive' },

  {
    'sindrets/diffview.nvim',
    init = function()
      vim.api.nvim_create_autocmd('VimEnter', {
        desc = 'Open diffview on commit messages',
        group = vim.api.nvim_create_augroup('open_diffview_on_commit', { clear = true }),
        callback = function(opts)
          if vim.bo[opts.buf].filetype == 'gitcommit' then
            vim.cmd 'DiffviewOpen --staged'
          end
        end,
      })
    end
  },

  {
    'ldelossa/gh.nvim',
    main = "litee.gh",
    opts = { icon_set = "nerd" },
    dependencies = {
      { 'ldelossa/litee.nvim', main = "litee.lib" }
    }
  },
}

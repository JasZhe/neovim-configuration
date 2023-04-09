return {
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = "make",
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope.nvim',               tag = "0.1.1" },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-telescope/telescope-live-grep-args.nvim' },
    },
    config = function()
      local telescope = require("telescope")
      local lga_actions = require("telescope-live-grep-args.actions")
      local tb = require('telescope.builtin')
      vim.keymap.set('n', '<leader>F', tb.find_files, { desc = "telescope find files" })
      vim.keymap.set('n', '<leader>U', tb.lsp_references, { desc = "telescope lsp references" })
      vim.keymap.set('n', '<leader>B', tb.buffers, { desc = "telescope buffers list" })
      telescope.load_extension("ui-select")
      telescope.load_extension("live_grep_args")
      telescope.setup {
        extensions = {
          live_grep_args = {
            auto_quoting = false,
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              },
            },
          }
        }
      }

      -- NOTE: this portion allows us to visual select and then fuzzy find the selection
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

      local opts = function(desc) return { noremap = true, silent = true, desc = desc } end

      vim.keymap.set('n', '<leader>gb', ':Telescope current_buffer_fuzzy_find<cr>',
        opts("telescope current buffer fuzzy find"))
      vim.keymap.set('v', '<leader>gb', function()
        local text = vim.getVisualSelection()
        tb.current_buffer_fuzzy_find({ default_text = text })
      end, opts("telescope current buffer fuzzy find"))

      vim.keymap.set('n', '<leader>G', ':Telescope live_grep_args<cr>', opts("telescope grep with args"))
      vim.keymap.set('v', '<leader>G', function()
        local text = vim.getVisualSelection()
        tb.live_grep({ default_text = text })
      end, opts("telescope grep with args"))

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

      vim.keymap.set("n", "<Leader>gh", git_hunks, { desc = "telescope git hunks" })
    end
  }
}

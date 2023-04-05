return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true },
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "help",
          "query",
          "go",
          "javascript",
          "python",
          "html",
          "css",
          "markdown",
        },
      }
    end,
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-context',
        main = 'treesitter-context'
      },
    },
  },
  {
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
        vim.keymap.set('n', '<leader>F', tb.find_files, {})
        vim.keymap.set('n', '<leader>U', tb.lsp_references, {})
        vim.keymap.set('n', '<leader>B', tb.buffers, {})
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

        local opts = { noremap = true, silent = true }

        vim.keymap.set('n', '<leader>gb', ':Telescope current_buffer_fuzzy_find<cr>', opts)
        vim.keymap.set('v', '<leader>gb', function()
          local text = vim.getVisualSelection()
          tb.current_buffer_fuzzy_find({ default_text = text })
        end, opts)

        vim.keymap.set('n', '<leader>G', ':Telescope live_grep_args<cr>', opts)
        vim.keymap.set('v', '<leader>G', function()
          local text = vim.getVisualSelection()
          tb.live_grep({ default_text = text })
        end, opts)

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

        vim.keymap.set("n", "<Leader>gh", git_hunks, {})
      end
    },
  },

  {
    'mfussenegger/nvim-dap',
    dependencies = {
      { 'leoluz/nvim-dap-go' },
      { 'rcarriga/nvim-dap-ui' },
      { 'theHamsta/nvim-dap-virtual-text' },
    }
  },

  {
    'VonHeikemen/lsp-zero.nvim',
    branch = "v1.x",
    dependencies = {
      { 'neovim/nvim-lspconfig' },
      {
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    },
    config = function()
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
        local opts = { buffer = bufnr }

        vim.keymap.set({ 'n', 'x' }, '<leader>ff', function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end, opts)
      end)

      lsp.nvim_workspace({
        library = vim.api.nvim_get_runtime_file('', true)
      })
      vim.opt.signcolumn = 'yes'
      lsp.setup()
    end
  },

  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = {},
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup {
        sources = {
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.completion.spell,
          null_ls.builtins.code_actions.gitsigns
        }
      }
    end
  },

  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach", -- hopefully should make it so this loads after lsp-zero
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" }
    },
    config = function()
      require("lspsaga").setup({
        outline = {
          keys = {
            expand_or_jump = "<CR>",
            expand_collapse = "t",
            win_width = 50
          }
        },
        finder = {
          keys = {
            expand_or_jump = '<CR>',
          }
        },
        lightbulb = {
          sign = false,
          virtual_text = false
        }
      })
      vim.keymap.set("n", "<C-]>", "<cmd>Lspsaga lsp_finder<CR>")
      vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>")
      vim.keymap.set("n", "gr", "<cmd>Lspsaga rename<CR>")
      vim.keymap.set("n", "gR", "<cmd>Lspsaga rename ++project<CR>")
      vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>")

      -- Diagnostic jump
      -- You can use <C-o> to jump back to your previous location
      vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
      vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")

      -- Diagnostic jump with filters such as only jumping to an error
      vim.keymap.set("n", "[E", function()
        require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end)
      vim.keymap.set("n", "]E", function()
        require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
      end)

      -- Toggle outline
      vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>")
    end
  }
}

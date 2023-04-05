return {
  {
    "jaszhe/grapple.nvim",
    branch = "telescope_ext",
    config = function()
      local grapple = require("grapple")
      vim.keymap.set("n", "<leader>gt",
        function()
          if (grapple.exists()) then
            vim.notify("Removing Grapple")
          else
            vim.notify("Adding Grapple")
          end
          grapple.toggle()
        end
      )
      --
      -- local generate_grapple_finder = function()
      --   local tags = grapple.tags()
      --   local results_list = {}
      --
      --   for idx, tag in ipairs(tags) do
      --     local filepath = tag.file_path
      --     local row, col = unpack(tag.cursor)
      --     table.insert(
      --       results_list,
      --       { idx, filepath, row, col }
      --     )
      --   end
      --
      --   return require("telescope.finders").new_table({
      --     results = results_list,
      --     entry_maker = function(entry)
      --       local utils = require("telescope.utils")
      --
      --       local ordinal = entry[1]
      --       local filepath = entry[2]
      --       local filepathDisplay = utils.transform_path({}, filepath)
      --       local lineNum = entry[3]
      --
      --       return {
      --         value = entry,
      --         filename = filepath,
      --         display = filepathDisplay,
      --         ordinal = ordinal,
      --         lnum = lineNum
      --       }
      --     end
      --   })
      -- end
      --
      -- local delete_grapple = function(prompt_bufnr)
      --   local action_state = require("telescope.actions.state")
      --   local selection = action_state.get_selected_entry()
      --
      --   grapple.untag({ file_path = selection.filename })
      --
      --   local current_picker = action_state.get_current_picker(prompt_bufnr)
      --   current_picker:refresh(generate_grapple_finder(), { reset_prompt = true })
      -- end
      --
      -- local grapple_hooks = function()
      --   local default_options = {
      --     sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
      --     previewer = require("telescope.config").values.grep_previewer {},
      --     results_title = "Grapple Hooks",
      --     prompt_title = "Grapple Hooks",
      --     layout_strategy = "flex",
      --   }
      --
      --   require("telescope.pickers")
      --       .new({
      --         finder = generate_grapple_finder(),
      --         attach_mappings = function(_, map)
      --           map("i", "<C-X>", delete_grapple)
      --           map("n", "<C-X>", delete_grapple)
      --           return true
      --         end
      --       }, default_options):find()
      -- end
      --
      require("telescope").load_extension('grapple')
      vim.keymap.set("n", "<Leader>M", ":Telescope grapple hooks<cr>")
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },

}

return {
  {
    'sidebar-nvim/sidebar.nvim',
    init = function()
      local utils = require("sidebar-nvim.utils")
      local Loclist = require("sidebar-nvim.components.loclist")
      local has_devicons, devicons = pcall(require, "nvim-web-devicons")

      local loclist = Loclist:new({ omit_single_group = true })
      local function get_fileicon(filename)
        if has_devicons and devicons.has_loaded() then
          local extension = filename:match("^.+%.(.+)$")

          local fileicon = ""
          local icon, highlight = devicons.get_icon(filename, extension)
          if icon then
            fileicon = icon
          end

          if not highlight then
            highlight = "SidebarNvimNormal"
          end

          return {
            text = "  " .. fileicon .. " ",
            hl = highlight,
          }
        else
          return { text = "   " }
        end
      end

      local function get_grapple_hooks(ctx)
        local loclist_items = {}

        local lines = {}
        local hl = {}
        local grapple = require("grapple")

        local tags = grapple.tags()
        local current_buffer_path = vim.api.nvim_buf_get_name(0)

        for _, tag in ipairs(tags) do
          local name_hl = "SidebarNvimNormal"
          local file_path = tag.file_path
          local cursor = tag.cursor
          local row, col = unpack(cursor)
          if file_path == current_buffer_path then
            name_hl = "SidebarNvimBuffersActive"
          end

          loclist_items[#loclist_items + 1] = {
            group = "grapples",
            left = {
              get_fileicon(file_path),
              { text = utils.filename(file_path), hl = name_hl },
              { text = " " .. row .. ":" .. col,              hl = "SidebarNvimBuffersNumber" },
            },
            data = { filepath = file_path, cursor = cursor },
          }
        end

        loclist:set_items(loclist_items, { remove_groups = false })
        loclist:draw(ctx, lines, hl)

        if lines == nil or #lines == 0 then
          return "<no grapples>"
        else
          return { lines = lines, hl = hl }
        end
      end

      local enter_tag = function(line)
        local location = loclist:get_location_at(line)
        if location == nil then
          return
        end

        local grapple = require("grapple")
        grapple.select({ file_path = location.data.filepath })
      end

      local grapple_hooks = {
        title = "Grapple Hooks",
        icon = "󰛢",
        draw = function(ctx)
          return get_grapple_hooks(ctx)
        end,
        highlights = {
          groups = {},
          links = {
            SidebarNvimBuffersActive = "SidebarNvimSectionTitle",
            SidebarNvimBuffersNumber = "SIdebarnvimLineNr",
          },
        },
        bindings = {
          ["d"] = function(line)
            local grapple = require("grapple")
            local location = loclist:get_location_at(line)

            if location == nil then
              return
            end

            grapple.untag({ file_path = location.data.filepath })
          end,
          ["<CR>"] = enter_tag,
          ["e"] = enter_tag,
        },
      }

      local sidebar = require("sidebar-nvim")
      sidebar.setup({
        sections = { grapple_hooks, "buffers", "diagnostics", "todos", "symbols" },
        update_interval = 500,
      })
      vim.keymap.set("n", "<leader>sb", "<cmd>SidebarNvimToggle<cr>")


      -- allow opening of buffers with enter
      local git_section = require("sidebar-nvim.builtin.buffers")
      git_section.bindings["<CR>"] = git_section.bindings["e"]

      -- allow opening todos with enter
      local todo_section = require("sidebar-nvim.builtin.todos")
      todo_section.bindings["<CR>"] = todo_section.bindings["e"]
    end
  },
}

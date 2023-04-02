local utils = require("sidebar-nvim.utils")
local Loclist = require("sidebar-nvim.components.loclist")
local config = require("sidebar-nvim.config")
local has_devicons, devicons = pcall(require, "nvim-web-devicons")

local loclist = Loclist:new({ omit_single_group = true })
local loclist_items = {}

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
  local lines = {}
  local hl = {}
  local grapple = require("grapple")

  local tags = grapple.tags()
  local current_buffer_path = vim.api.nvim_buf_get_name(0)

  for file_path, _ in ipairs(tags) do
    local name_hl = "SidebarNvimNormal"
    if file_path == current_buffer_path then
      name_hl = "SidebarNvimBuffersActive"
    end

    loclist_items[#loclist_items + 1] = {
      group = "grapples",
      left = {
        get_fileicon(file_path),
        { text = utils.filename(file_path), hl = name_hl },
      },
      data = { filepath = file_path },
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

return {
  title = "Grapple Hooks",
  icon = config["buffers"].icon,
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

      grapple.untag({file_path = location.data.filepath})
    end,
    ["e"] = function(line)
      local location = loclist:get_location_at(line)
      if location == nil then
        return
      end

      vim.cmd("wincmd p")
      vim.cmd("e " .. location.data.filepath)
    end,
  },
}

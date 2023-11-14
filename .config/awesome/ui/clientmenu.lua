local gears     = require("gears")
local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi
local naughty   = require("naughty")
local rubato    = require("libs.rubato")
local helpers   = require("ui.helpers")

local M = {}

M.menu = function (c)

  local margin = 0

  local menu = wibox {
  visible = false,
  -- height = c:geometry().height - margin*2,
  -- width = c:geometry().width - margin*2,
  -- x = c:geometry().x + beautiful.border_width + margin,
  -- y = c:geometry().y + beautiful.border_width + margin,
  x = mouse.coords().x,
  y = mouse.coords().y,
  width = dpi(250),
  height = dpi(250),
  -- bg = "#aa0",
  -- opacity = 1,
  -- shape = helpers.rounded(8),
  -- screen = c.screen
  ontop = true,
  sticky = false,
  input_passthrough = false,
}

  menu:setup {
    {
      widget = wibox.container.background,
      bg = "#282828",
      shape = helpers.rounded(8),
      shape_border_width = dpi(1),
      shape_border_color = "#665c54",
      id = "menu_box",
    },
    widget = wibox.container.margin,
    id     = "menu_outside_margins",
    -- top    = c:geometry().height * 0.1,
    -- bottom = c:geometry().height * 0.1,
    -- left   = c:geometry().width * 0.1,
    -- right  = c:geometry().width * 0.1,
    -- color = "#a00",
    -- opacity = 0,
  }



  for _, signal in pairs({ "request::geometry", "property::maximized", "property::floating", "property::x"}) do
    c:connect_signal(signal, function(c)
      -- menu.height = c:geometry().height - margin*2
      -- menu.width  = c:geometry().width  - margin*2
      -- menu.x      = c:geometry().x + beautiful.border_width + margin
      -- menu.y      = c:geometry().y + beautiful.border_width + margin

      local margins = menu:get_children_by_id("menu_outside_margins")[1]
      -- margins.top    = c:geometry().height * 0.1
      -- margins.bottom = c:geometry().height * 0.1
      -- margins.left   = c:geometry().width * 0.1
      -- margins.right  = c:geometry().width * 0.1

    end)
  end

  c:connect_signal("unfocus", function(c)
    menu.visible = false
  end)

  local menubox = menu:get_children_by_id("menu_box")[1]
  helpers.hover(menubox,
    {
      cursor = "hand1",
    })

  return menu
end


return M

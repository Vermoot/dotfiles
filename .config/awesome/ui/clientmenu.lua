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

  local menu = awful.popup {
    minimum_width  = dpi(250),
    minimum_height = dpi(250),
    widget = {
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
    },
    visible = false,
    ontop = true,
    placement = awful.placement.next_to_mouse,
    -- x = mouse.coords().x,
    -- y = mouse.coords().y,
    shape = gears.shape.rounded_rect,
    border_width = dpi(1),
    border_color = "#665c54",
    size = { width = dpi(250), height = dpi(250) },
  }

  for _, signal in pairs({ "request::geometry", "property::maximized", "property::floating", "property::x" }) do
    c:connect_signal(signal, function(c)
      local margins = menu.widget:get_children_by_id("menu_outside_margins")[1]
      -- Adjust margins or other properties based on window changes
    end)
  end

  c:connect_signal("unfocus", function(c)
    menu.visible = false
  end)

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

  local menubox = menu.widget:get_children_by_id("menu_box")[1]
  helpers.hover(menubox, {
    cursor = "hand1",
  })

  return menu
end

return M

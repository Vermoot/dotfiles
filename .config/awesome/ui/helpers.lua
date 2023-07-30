local gears     = require("gears")
local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi

local M = {}

M.rounded = function (radius)
  return function (widget, width, height)
    gears.shape.rounded_rect(widget, width, height, dpi(radius))
  end
end

M.hover_cursor = function (widget, cursor)
  widget:connect_signal('mouse::enter', function()
    local w = mouse.current_wibox
    if w then
      old_cursor, wibox_before_cursor = w.cursor, w
      w.cursor = cursor
    end
  end)

  widget:connect_signal('mouse::leave', function()
    local w = mouse.current_wibox
    if wibox_before_cursor then
      wibox_before_cursor.cursor = old_cursor
      wibox_before_cursor = nil
    end
  end)
end

M.hover_colors = function (widget, new_border, new_bg)
  widget:connect_signal('mouse::enter', function()
    -- local w = mouse.current_wibox
    -- if w then
      old_border, old_bg, wibox_before_colors = widget.shape_border_color, widget.bg, widget
      widget.shape_border_color = new_border
      widget.bg = new_bg
    -- end
  end)

  widget:connect_signal('mouse::leave', function()
    -- local w = mouse.current_wibox
    if wibox_before_colors then
      wibox_before_colors.shape_border_color = old_border
      wibox_before_colors.bg = old_bg
      wibox_before_colors = nil
    end
  end)
end

return M

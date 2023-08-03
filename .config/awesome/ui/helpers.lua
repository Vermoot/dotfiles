local gears     = require("gears")
local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi
local naughty   = require("naughty")

local M = {}

M.rounded = function (radius)
  return function (widget, width, height)
    gears.shape.rounded_rect(widget, width, height, dpi(radius))
  end
end

M.hover_properties = function (w, inhibitor)

  inhibitor = inhibitor or function() return false end

  w:connect_signal('mouse::enter', function()

    if inhibitor() then return end

    w.before = w.before or {}

    if w.hover_shape_border_color then
      w.before.shape_border_color = w.shape_border_color
      w.shape_border_color = w.hover_shape_border_color
    end

    if w.hover_bg then
      w.before.bg = w.bg
      w.bg = w.hover_bg
    end

    if w.hover_cursor then
      w.mw = mouse.current_wibox
      if w.mw then
        w.before.cursor = w.mw.cursor
        w.mw.cursor = w.hover_cursor
      end
    end

  end)

  w:connect_signal('mouse::leave', function()

    if inhibitor() then return end

    if w.before.shape_border_color then
      w.shape_border_color = w.before.shape_border_color
    end

    if w.before.bg then
      w.bg = w.before.bg
    end

    if w.before.cursor then
      if w.mw then w.mw.cursor = w.before.cursor end
    end

    w.before = nil
  end)
end

return M

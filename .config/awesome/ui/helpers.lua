local gears     = require("gears")
local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi
local naughty   = require("naughty")
local dragndropper = require("ui.dragndropper")

local M = {}

M.rounded = function (radius)
  return function (widget, width, height)
    gears.shape.rounded_rect(widget, width, height, dpi(radius))
  end
end

M.hover = function (w, args)

  w:connect_signal('mouse::enter', function()

    if args.inhibitor and args.inhibitor() then return end

    w.before = w.before or {}

    for property, value in pairs(args) do
      if property == "cursor" then
        w.mw = mouse.current_wibox
        if w.mw then
          w.before.cursor = w.mw.cursor
          w.mw.cursor = value
        end
      else
        w.before[property] = w[property]
        w[property] = value
      end
    end

  end)

  w:connect_signal('mouse::leave', function()

    if args.inhibitor and args.inhibitor() then return end

    w.before = w.before or {}

    for property, _ in pairs(args) do
      if property == "cursor" then
        w.mw = mouse.current_wibox
        if w.mw then
          w.mw.cursor = w.before.cursor
          w.before.cursor = nil
        end
      else
        w[property] = w.before[property]
        w.before[property] = nil
      end
    end


    -- w.before = nil
  end)
end

return M

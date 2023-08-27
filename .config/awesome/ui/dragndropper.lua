local gears     = require("gears")
local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi
local naughty   = require("naughty")

local M = {}

LMB_down = false

M.test = function (w)
  w:connect_signal("mouse::enter", function()
    naughty.notify({ preset = naughty.config.presets.critical,
      title = "LMB",
      text = tostring(mouse.is_left_mouse_button_pressed)})
  end)
end

return M

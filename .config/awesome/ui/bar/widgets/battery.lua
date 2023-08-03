local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local gears     = require("gears")
local dpi       = require("beautiful.xresources").apply_dpi
local naughty   = require("naughty")
local helpers   = require("ui.helpers")

local M = {}

local current_charge = 50
local charging = false
local low_battery = 25

local colors = function ()
  if charging then
    return { background = "#79740e", foreground = "#98971a" }
  elseif current_charge <= low_battery then
    return { background = "#cc241d", foreground = "#fb4934" }
  else
    return { background = "#504945", foreground = "#665c54" }
  end
end

M.widget = wibox.widget {
  {
    {
      max_value        = 100,
      value            = current_charge,
      forced_width     = dpi(50),
      paddings         = dpi(2),
      widget           = wibox.widget.progressbar,
      shape            = helpers.rounded(5),
      bar_shape        = helpers.rounded(5),
      color            = colors().foreground,
      background_color = colors().background,
      id               = "battery_progress_bar",
    },
    direction = "east",
    layout = wibox.container.rotate
  },
  {
    markup = "<span font='SF Compact Rounded 12' foreground='#282828' font-weight='700'>"
      .. current_charge ..
    "</span>",
    valign = "center",
    halign = "center",
    id = "percent_textbox",
    widget = wibox.widget.textbox,
  },
  layout = wibox.layout.stack,
}

local battery_progress_bar = M.widget:get_children_by_id("battery_progress_bar")[1]
local percent_textbox = M.widget:get_children_by_id("percent_textbox")[1]

gears.timer {
  timeout   = 1,
  call_now  = true,
  autostart = true,
  callback  = function()
    awful.spawn.easy_async_with_shell(
      'acpi',
      function(out)
        charging = string.find(out, "Charging") ~= nil
        current_charge = tonumber(string.match(out, "(%d+)%%"))
        battery_progress_bar.value = current_charge
        percent_textbox.markup = "<span font='SF Compact Rounded 12' foreground='#282828' font-weight='700'>" .. current_charge .. "</span>"
      end
    )
    battery_progress_bar.color = colors().foreground
    battery_progress_bar.background_color = colors().background
  end
}

local nobattery = false
if nobattery then
  M.widget = { widget = wibox.container.background }
end

return M

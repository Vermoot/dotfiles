local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local gears     = require("gears")
local dpi       = require("beautiful.xresources").apply_dpi
local naughty   = require("naughty")

local M = {}

local current_charge = 80
local charging = true

local colors = function ()
  if tonumber(current_charge) < 20 then
    return { background = "#cc241d", foreground = "#fb4934" }
  elseif charging then
    return { background = "#79740e", foreground = "#98971a" }
  else
    return { background = "#3c3836", foreground = "#665c54" }
  end
end

M.widget = wibox.widget {
  {
    {
      max_value     = 100,
      value         = current_charge,
      forced_width  = dpi(50),
      paddings      = dpi(2),
      -- paddings      = 0,
      widget        = wibox.widget.progressbar,
      shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, dpi(5))
      end,
      bar_shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, dpi(5))
      end,
      color = colors().foreground,
      background_color = colors().background,
      id = "battery_progress_bar",
    },
    direction = "east",
    layout = wibox.container.rotate
  },
  {
    -- text = 50,
    -- font = "SF Compact Rounded Bold 12",
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

gears.timer {
  timeout = 1,
  call_now = true,
  autostart = true,
  callback = function()
    awful.spawn.easy_async(
      "cat /sys/class/power_supply/BAT0/status",
      function(out) charging = out == "Charging\n" end
    )
    awful.spawn.easy_async(
      "cat /sys/class/power_supply/BAT0/capacity",
      function(out)
        current_charge = tonumber(out)
        -- M.widget:get_children_by_id("battery_progress_bar")[1].value = current_charge
        -- M.widget:get_children_by_id("percent_textbox")[1].markup = "<span font='SF Compact Rounded 12' foreground='#282828' font-weight='700'>" .. current_charge .. "</span>"
        -- M.widget:get_children_by_id("battery_progress_bar")[1].color = colors().foreground
        -- M.widget:get_children_by_id("battery_progress_bar")[1].background_color = colors().background
      end
    )
  end
}

local nobattery = false
if nobattery then
  M.widget = { widget = wibox.container.background }
end

return M

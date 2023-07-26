local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local gears     = require("gears")
local dpi       = require("beautiful.xresources").apply_dpi
local naughty   = require("naughty")

local M = {}

local systray = wibox.widget.systray()
M.widget = function (s)
    if s.index == 1 then
        return wibox.widget {
            {
                systray,
                -- margins = dpi(2),
                top = dpi(4),
                bottom = dpi(4),
                left = dpi(2),
                right =dpi(2),
                widget = wibox.container.margin
            },
            widget = wibox.container.background,
            bg = "#665c54",
            visible = function (s) return s.index == 1 end,
            shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, dpi(5))
            end,
        }
    end
end
systray:set_horizontal(false)
-- systray:set_base_size(24)
beautiful.bg_systray = "#665c54"
beautiful.systray_icon_spacing = dpi(4)

return M

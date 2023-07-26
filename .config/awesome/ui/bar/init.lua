local gears     = require("gears")
local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi

local battery = require("ui.bar.widgets.battery")
local clock   = require("ui.bar.widgets.clock")
local systray = require("ui.bar.widgets.systray")
local taglist = require("ui.bar.widgets.taglist")

awful.screen.connect_for_each_screen(function(s)
    s.myBar = wibox {
        height  = s.geometry.height - 4 * beautiful.useless_gap,
        width   = dpi(42),
        ontop   = true,
        visible = true,
        x       = s.geometry.x + 2 * beautiful.useless_gap,
        y       = s.geometry.y + 2 * beautiful.useless_gap,
        bg      = "aa0000",
        type    = "Normal",
        screen  = s,
        shape   = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, dpi(8))
        end
    }

    -- Add widgets to the wibox
    s.myBar:setup {
        {
            {
                layout = wibox.layout.align.vertical,
                { -- Top widgets
                    taglist.taglist(s),
                    layout = wibox.layout.fixed.vertical,
                },
                taglist.tasklist(s, "1"),
                { -- Bottom widgets
                    systray.widget(s),
                    battery.widget,
                    clock.widget,
                    spacing = dpi(6),
                    layout = wibox.layout.fixed.vertical,
                },
            },
            widget = wibox.container.margin,
            top    = dpi(6),
            bottom = dpi(5),
            left   = dpi(5),
            right  = dpi(5),
        },
        widget = wibox.container.background,
        bg = "#282828",
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, dpi(8))
        end,
        shape_border_width = dpi(1),
        shape_border_color = "#665c54",
    }

    s.myBar:struts {
        left = s.myBar.width + 2 * beautiful.useless_gap
    }

end)

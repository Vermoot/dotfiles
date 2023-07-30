local gears     = require("gears")
local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi
local helpers = require("ui.helpers")

local battery     = require("ui.bar.widgets.battery")
local clock       = require("ui.bar.widgets.clock")
local systray     = require("ui.bar.widgets.systray")
local tagtasklist = require("ui.bar.widgets.tagtasklist")

awful.screen.connect_for_each_screen(function(s)
    s.bar = wibox {
        height  = s.geometry.height - 4 * beautiful.useless_gap,
        width   = dpi(42),
        ontop   = true,
        visible = true,
        x       = s.geometry.x + 2 * beautiful.useless_gap,
        y       = s.geometry.y + 2 * beautiful.useless_gap,
        bg      = "aa0000",
        type    = "Normal",
        screen  = s,
        shape   = helpers.rounded(8),
    }

    -- Add widgets to the wibox
    s.bar:setup {
        {
            {
                layout = wibox.layout.align.vertical,
                { -- Top widgets
                    -- taglist.taglist(s),
                    -- fancy_taglist.new({screen = s}),
                    tagtasklist.widget(s),
                    layout = wibox.layout.flex.vertical,
                },
                -- tasklist.widget(s, "1"),
                {layout=wibox.layout.fixed.vertical},
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
            bottom = dpi(6),
            left   = dpi(5),
            right  = dpi(5),
        },
        widget = wibox.container.background,
        bg = "#282828",
        shape = helpers.rounded(8),
        shape_border_width = dpi(1),
        shape_border_color = "#665c54",
    }

    s.bar:struts {
        left = s.bar.width + 2 * beautiful.useless_gap
    }

end)

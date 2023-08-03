local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local gears     = require("gears")
local dpi       = require("beautiful.xresources").apply_dpi
local naughty   = require("naughty")

local helpers = require("ui.helpers")

local M = {}

M.widget = wibox.widget {
    {
        {
            {
                align = "center",
                valign = "center",
                -- format = "%H",
                widget = wibox.widget.textclock("<span font='SF Compact Rounded 12' font-weight='700'>%H</span>")
            },
            -- {
            --     bg = "#3c3836",
            --     forced_height = dpi(2),
            --     forced_width = dpi(8),
            --     shape = function(cr, width, height)
            --         gears.shape.rounded_rect(cr, width, height, dpi(5))
            --     end,
            --     widget = wibox.container.background
            -- },
            {
                align = "center",
                valign = "center",
                -- format = "%M",
                widget = wibox.widget.textclock("<span font='SF Compact Rounded 12' font-weight='700'>%M</span>")
            },
            spacing = dpi(-4),
            layout = wibox.layout.fixed.vertical

        },
        margins = dpi(0),
        widget = wibox.container.margin
    },
    bg = "#665c54",
    fg = "#282828",
    shape = helpers.rounded(5),
    widget = wibox.container.background,
}

local date_tooltip = awful.tooltip {
    objects = {M.widget},
    -- timer_function = function () return os.date("%d %B %Y") end,
    markup = "<span font='SF Compact Rounded Medium 12'>" .. os.date("%A %d %B %Y") .. "</span>",
    shape = helpers.rounded(4),
    border_width = dpi(1),
    border_color = "#3c3836",
    bg = "#665c54",
    fg = "#282828",
    preferred_alignments = {"back"},
    mode = "outside",
    delay_show = 0.5,
}

return M

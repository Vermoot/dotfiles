local gears     = require("gears")
local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi
local naughty   = require("naughty")

local s = awful.screen.focused()

local volume = {}

local hud_width  = 250
local hud_height = 40
local hud_margin = 32
local hud_radius = 12
local hud_border = 2

local volume_hud = wibox {
    visible = true,
    screen = 1,
    type = "dock",
    ontop = true,
    height = hud_height,
    width = hud_width,
    x = (s.geometry.width / 2) - hud_width / 2,
    -- y = s.geometry.height - hud_margin - hud_height,
    y = 1050 + s.geometry.height,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, hud_radius)
    end,
}

local volume_symbol = ""
local volume_value  = 50

local slider = wibox.widget.slider {
    bar_shape           = gears.shape.rounded_rect,
    bar_active_color    = "#689d6a",
    bar_height          = 6,
    bar_color           = "#ebdbb2",
    handle_shape        = gears.shape.circle,
    handle_width        = 6,
    handle_color        = "#689d6a",
    value               = volume_value,
    widget              = wibox.widget.slider,
}
volume_hud : setup {
    {
        {
            {
                markup = "<span foreground='#bdae93'>" .. volume_symbol .. "</span>",
                align = "center",
                valign = "center",
                font = "20",
                widget = wibox.widget.textbox
            },
            slider,
            spacing = 12,
            layout = wibox.layout.fixed.horizontal
        },
        widget = wibox.container.margin,
        left = 16,
        right = 16,
    },
    widget = wibox.container.background,
        bg = "#504945",
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, hud_radius)
        end,
        shape_border_width = hud_border,
        shape_border_color = "#a89984",

}

timer = gears.timer {
    timeout = 2,
    callback = function ()
        volume_hud.y = 1050 + s.geometry.height
    end
}
volume.update = function (value)
    awful.spawn.easy_async_with_shell("pamixer --get-volume", function(volume_got)
        awful.spawn.easy_async_with_shell("pamixer --set-volume " .. volume_got + value .. " --unmute", function () end)
        awful.spawn.easy_async_with_shell("pamixer --get-volume", function(new_volume)
            slider:set_value(tonumber(new_volume))
            volume_hud.y = 1050 + s.geometry.height - hud_height - hud_margin
            timer:again()
        end)
    end)
end

return volume

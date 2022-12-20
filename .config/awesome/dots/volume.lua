local gears     = require("gears")
local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi
local naughty   = require("naughty")
local rubato    = require("libs.rubato")


local volume = {}

local hud_screen   = awful.screen.focused()
local hud_width    = dpi(250)
local hud_height   = dpi(40)
local hud_margin   = dpi(32)
local hud_radius   = dpi(12)
local hud_border   = dpi(2)
local hud_duration = 0.5

local volume_hud = wibox {
    visible = true,
    screen  = hud_screen,
    type    = "dock",
    ontop   = true,
    height  = hud_height,
    width   = hud_width,
    x       = (hud_screen.geometry.width / 2) - hud_width / 2,
    y       = hud_screen.geometry.y + hud_screen.geometry.height,
    shape   = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, hud_radius)
    end,
}

local volume_muted = false
local volume_value = 50
local volume_symbol = function ()
    if volume_muted or volume_value == 0 then
        return ""
    elseif volume_value < 32 then
        return ""
    elseif volume_value < 66 then
        return ""
    else
        return ""
    end
end
-- local volume_symbol = ""

local slider = wibox.widget.slider {
    bar_shape           = gears.shape.rounded_rect,
    bar_active_color    = "#689d6a",
    bar_height          = dpi(6),
    bar_color           = "#ebdbb2",
    handle_shape        = gears.shape.circle,
    handle_width        = dpi(6),
    handle_color        = "#689d6a",
    value               = volume_value,
}

local volume_icon = wibox.widget {
                align = "center",
                valign = "center",
                font = "SF Compact Rounded 19",
                widget = wibox.widget.textbox
}

volume_hud : setup {
    {
        {
            volume_icon,
            slider,
            spacing = dpi(12),
            layout = wibox.layout.fixed.horizontal
        },
        widget = wibox.container.margin,
        left = dpi(16),
        right = dpi(16),
    },
    widget = wibox.container.background,
        bg = "#504945",
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, hud_radius)
        end,
        shape_border_width = hud_border,
        shape_border_color = "#a89984",

}

local rubato_timer = rubato.timed {
    duration = 0.1,
    pos = volume_value,
    easing = rubato.easing.linear,
    subscribed = function(value)
        slider.value = value
    end
}

local timer = gears.timer {
    timeout = hud_duration,
    callback = function ()
        volume_hud.y = hud_screen.geometry.y + hud_screen.geometry.height
    end
}

local function restyle (mute)
    if mute then
        slider.bar_color = "#7c6f64"
        slider.handle_color = "#282828"
        slider.bar_active_color = "#282828"
        volume_icon:set_markup_silently("<span foreground='#fb4934'>" .. volume_symbol() .. "</span>")
    else
        slider.bar_color = "#ebdbb2"
        slider.handle_color = "#689d6a"
        slider.bar_active_color = "#689d6a"
        volume_icon:set_markup_silently("<span foreground='#bdae93'>" .. volume_symbol() .. "</span>")
    end
end
volume.update = function (value)
    awful.spawn.easy_async_with_shell("pamixer --get-volume", function(volume_got)
        awful.spawn.easy_async_with_shell("pamixer --set-volume " .. volume_got + value .. " --unmute", function ()
            awful.spawn.easy_async_with_shell("pamixer --get-volume", function(new_volume)
                volume_muted = false
                restyle(false)
                volume_value = tonumber(new_volume)
                rubato_timer.target = tonumber(new_volume)
                volume_hud.y = hud_screen.geometry.y + hud_screen.geometry.height - hud_height - hud_margin
                timer:again()
            end)
        end)
    end)
end

-- TODO This doesn't toggle visually
volume.toggle_mute = function()
    awful.spawn.easy_async_with_shell("pamixer -t", function()
        awful.spawn.easy_async_with_shell("pamixer --get-mute", function(muted)
            naughty.notify({title=muted})
            if muted == "false" then
                naughty.notify({title="Not muted"})
                volume_muted = false
                restyle(false)
            else
                naughty.notify({title="Muted"})
                volume_muted = true
                restyle(true)
            end
        end)
    end)
    volume_hud.y = hud_screen.geometry.y + hud_screen.geometry.height - hud_height - hud_margin
    timer:again()
end

return volume

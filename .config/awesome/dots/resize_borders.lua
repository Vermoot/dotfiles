local gears     = require("gears")
local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi
local naughty   = require("naughty")

local M = {}

local handle_size = 10
local corner_radius = 12

local function handle()

    local the_handle = wibox {
        height = handle_size,
        width = handle_size,
        ontop = true,
        visible = false,
        bg = "#88aa00",
        -- input_passthrough = true,
        cursor = "sb_v_double_arrow",
        opacity = 0.5,
    }

    the_handle:setup {
        -- {},
        widget = wibox.container.background,
        -- bg = "#88aa00",
    }

    return the_handle
end

local handles = {
    n = handle(),
    s = handle()
}

handles.n:connect_signal("mouse::press", function()
    naughty.notify({ title = "yo" })
end)

local function update_handles(c)
    if handles.n ~= nil then
        if c == client.focus then
            handles.n.c = c
            handles.n.x = handles.n.c.x + corner_radius
            handles.n.y = handles.n.c.y + beautiful.border_width / 2 - handle_size / 2
            handles.n.width = handles.n.c.width - 2 * corner_radius
        end
    end

    if handles.s ~= nil then
        if c == client.focus then
            handles.s.c = c
            handles.s.x = handles.s.c.x + corner_radius
            handles.s.y = handles.s.c.y + handles.s.c.height + beautiful.border_width * 1.5 - handle_size / 2
            handles.s.width = handles.s.c.width - 2 * corner_radius
        end
    end
end

local function show_handles(c)
    if handles.n ~= nil then
        update_handles(c)
        -- for handle in handles do
        --     handle.visible = true
        -- end
        handles.n.visible = true
        handles.s.visible = true
    end
end

local function hide_handles(c)
    if handles.n ~= nil then
        handles.n.visible = false
        handles.s.visible = false
    end
end

client.connect_signal("request::manage", show_handles)
client.connect_signal("focus", show_handles)
client.connect_signal("unfocus", hide_handles)
client.connect_signal("request::unmanage", hide_handles)
client.connect_signal("property::geometry", update_handles)
client.connect_signal("property::floating", update_handles)


return M

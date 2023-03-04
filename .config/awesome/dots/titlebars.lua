local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi

local rubato = require ("libs.rubato")
local color = require("libs.color")

local titlebars = {}


client.connect_signal("request::titlebars", function(c)

    -- Mouse buttons on titlebars {{{
    function double_click_event_handler(double_click_event)
        if double_click_timer then
            double_click_timer:stop()
            double_click_timer = nil
            return true
        end

        double_click_timer = gears.timer.start_new(0.20, function()
            double_click_timer = nil
            return false
        end)
    end

    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
             -- WILL EXECUTE THIS ON DOUBLE CLICK
                if double_click_event_handler() then
                    c.maximized = not c.maximized
                    c:raise()
                else
                    awful.mouse.client.move(c)
                end
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )
    -- }}}

    -- Border color change logic {{{
    local r, g, b = color.utils.hex_to_rgba(c.border_color)
    local r_timed = rubato.timed {duration=0.2, pos=r}
    local g_timed = rubato.timed {duration=0.2, pos=g}
    local b_timed = rubato.timed {duration=0.2, pos=b}

    local function update_border_color ()
        if c ~= nil then
            c.border_color = "#"..color.utils.rgba_to_hex {
                math.max(r_timed.pos, 0),
                math.max(g_timed.pos, 0),
                math.max(b_timed.pos, 0)
            }
        end
    end

    r_timed:subscribe(update_border_color)
    g_timed:subscribe(update_border_color)
    b_timed:subscribe(update_border_color)

    local function set_border_color(c, new_color)
        r_timed.target, g_timed.target, b_timed.target = color.utils.hex_to_rgba(new_color)
    end

    local function deco_button (c, button, focused_color, unfocused_color)
        local action_button = button(c)
        -- action_button:connect_signal("mouse::enter", function ()
        --     initial_border_color = client.focus == c and beautiful.border_focus or beautiful.border_normal
        --     if c.focus then
        --         set_border_color(c, focused_color)
        --     else
        --         set_border_color(c, unfocused_color)
        --     end
        -- end)
        -- action_button:connect_signal("mouse::leave", function()
        --     set_border_color(c, initial_border_color)
        -- end)
        return action_button
    end
    -- }}}

    if c.width > c.height then
    -- Left titlebar {{{
    awful.titlebar(c, { position="left", size = dpi(32)}) : setup
    {
        {
            { -- Top
                {
                    deco_button(c, awful.titlebar.widget.closebutton,     "#fb4934", "#cc241d"),
                    deco_button(c, awful.titlebar.widget.maximizedbutton, "#fabd2f", "#d79921"),
                    deco_button(c, awful.titlebar.widget.minimizebutton,  "#b8bb26", "#98971a"),
                    spacing = dpi(6),
                    layout = wibox.layout.fixed.vertical,
                },
                margins = dpi(8),
                widget = wibox.container.margin
            },
            { -- Middle
                {
                    { -- Title
                        align  = "center",
                        widget = awful.titlebar.widget.titlewidget(c)
                    },
                    direction = 'east',
                    widget    = wibox.container.rotate
                },
                margins = 4,
                opacity = 0,
                buttons = buttons,
                widget = wibox.container.margin,
            },
            { -- Bottom
                {
                    awful.titlebar.widget.iconwidget(c),
                    layout  = wibox.layout.fixed.vertical(),
                },
                margins = 7,
                widget = wibox.container.margin
            },
            layout = wibox.layout.align.vertical,
        },
        {
            bg = "#ebdbb2",
            fixed_width = 4,
            fixed_height = 50,
            widget = wibox.container.background,
        },
        layout = wibox.layout.align.horizontal
    }
    -- }}}
    else
    -- Top titlebar {{{
    awful.titlebar(c, { position="top", size = dpi(32)}) : setup
    {
        { -- Left
            {
                deco_button(c, awful.titlebar.widget.closebutton,     "#fb4934", "#cc241d"),
                deco_button(c, awful.titlebar.widget.maximizedbutton, "#fabd2f", "#d79921"),
                deco_button(c, awful.titlebar.widget.minimizebutton,  "#b8bb26", "#98971a"),
                spacing = dpi(6),
                layout = wibox.layout.fixed.horizontal,
            },
            margins = dpi(8),
            widget = wibox.container.margin
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            margins = 4,
            widget = wibox.container.margin,
            opacity = 0,
            buttons = buttons,
            layout  = wibox.layout.flex.vertical,
        },
        { -- Bottom
            {
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout  = wibox.layout.fixed.vertical(),
            },
            margins = dpi(8),
            widget = wibox.container.margin
        },
        
        
        layout = wibox.layout.align.horizontal,
    }
    -- }}}
    end

end)

local function titlebar_position(c)
    if c.width >= c.height then return "left" else return "top" end
end

-- Exported functions {{{
titlebars.show = function(c)
    if c ~= nil then
        c.titlebar_shown = true
        awful.titlebar.show(c, titlebar_position(c))
    end
end

titlebars.hide = function(c)
    if c ~= nil then
        c.titlebar_shown = false
        awful.titlebar.hide(c, "top")
        awful.titlebar.hide(c, "left")
    end
end

titlebars.toggle = function(c)
    if c ~= nil then
        if c.titlebar_shown then
            titlebars.hide(c)
        else
            titlebars.show(c)
        end
    end
end
-- }}}

local function update(c)
    if c.titlebar_shown then
        if c.width > c.height then
            awful.titlebar.hide(c, "top")
            -- awful.titlebar.show(c, "left")
            c:emit_signal("request::titlebars")
        else
            awful.titlebar.hide(c, "left")
            -- awful.titlebar.show(c, "top")
            c:emit_signal("request::titlebars")
        end
    end
end

client.connect_signal("property::width", update)
client.connect_signal("property::height", update)

return titlebars

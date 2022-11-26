local gears     = require("gears")
local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi


-- Widgets {{{

-- Create a textclock widget

local clock = wibox.widget {
    {
        {
            {
                align = "center",
                valign = "center",
                -- format = "%H",
                widget = wibox.widget.textclock("<span font='SF Compact Rounded 15' font-weight='700'>%H</span>")
            },
            {
                bg = "#928374",
                forced_height = dpi(3),
                shape = function(cr, width, height)
                    gears.shape.rounded_rect(cr, width, height, dpi(5))
                end,
                widget = wibox.container.background
            },
            {
                align = "center",
                valign = "center",
                -- format = "%M",
                widget = wibox.widget.textclock("<span font='SF Compact Rounded 15' font-weight='700'>%M</span>")
            },
            spacing = dpi(-2),
            layout = wibox.layout.fixed.vertical
        },
        margins = dpi(0),
        widget = wibox.container.margin
    },
    fg = "#928374",
    widget = wibox.container.background
}

local clock2 = wibox.widget {
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
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, dpi(5))
    end,
    widget = wibox.container.background
}

local date_tooltip = awful.tooltip {
    objects = {clock2},
    -- timer_function = function () return os.date("%d %B %Y") end,
    markup = "<span font='SF Compact Rounded Medium 12'>" .. os.date("%A %d %B %Y") .. "</span>",
    shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, dpi(4)) end,
    border_width = dpi(1),
    border_color = "#3c3836",
    bg = "#665c54",
    fg = "#282828",
    preferred_alignments = {"back"},
    mode = "outside",
    delay_show = 0.5,
}

-- local date_popup = awful.popup {
--     {
--         text = "heyo",
--         widget = wibox.widget.textbox,
--     },
--     widget = wibox.container.background,
-- }
--
-- date_popup:move_next_to(mouse.current_widget_geometry)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(-1)
    end))

local systray = wibox.widget.systray()
local systray_widget = wibox.widget {
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
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, dpi(5))
    end,
}
systray:set_horizontal(false)
-- systray:set_base_size(24)
beautiful.bg_systray = "#665c54"
beautiful.systray_icon_spacing = dpi(4)

--}}}

awful.screen.connect_for_each_screen(function(s)

    -- Create a tasklist widget
    local tagtasklist = function(s, tag)
        s.mytasklist = awful.widget.tasklist {
            screen          = s,
            filter          = awful.widget.tasklist.filter.alltags,
            buttons         = tasklist_buttons,
            layout          = { layout = wibox.layout.fixed.vertical, spacing = dpi(4) },
            widget_template = {
                {
                    {
                        layout = wibox.layout.fixed.vertical,
                    },
                    left   = dpi(4),
                    right  = dpi(4),
                    widget = wibox.container.margin
                },
                bg = "#00aa00",
                forced_height = dpi(12),
                forced_width = dpi(12),
                widget = wibox.container.background,
                shape = function(cr, width, height)
                    gears.shape.circle(cr, width, height)
                end,
                create_callback = function(self, c, index, objects)
                    self.filter = function() return c.first_tag == tag end
                end,


            },
        }
        return s.mytasklist
    end


    local yay_tasklist
    local tag_widget = {
        {
            yay_tasklist,
            layout = wibox.layout.fixed.vertical,
        },
        forced_height = dpi(24),
        widget = wibox.container.background,
        shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, dpi(4)) end,
        shape_border_width = dpi(2),
        shape_border_color = "#aa0000",

        -- Add support for hover colors and an index label
        create_callback = function(self, c3, index, objects) --luacheck: no unused args
            if c3.selected then
                self.shape_border_color = "#ebdbb2"
            else
                self.shape_border_color = "#665c54"
            end
            yay_tasklist = tagtasklist(s, c3)
            self:connect_signal('mouse::enter', function()
                self.border_backup = self.shape_border_color
                self.has_backup    = true
                if not c3.selected then self.shape_border_color = '#7c6f64' end

                local w = mouse.current_wibox
                if w and not c3.selected then
                    old_cursor, old_wibox = w.cursor, w
                    w.cursor = "hand1"
                end

            end)
            self:connect_signal('mouse::leave', function()
                if self.has_backup and not c3.selected then self.shape_border_color = self.border_backup end

                local w = mouse.current_wibox
                if old_wibox then
                    old_wibox.cursor = old_cursor
                    old_wibox = nil
                end
            end)

        end,

        update_callback = function(self, c3, index, objects) --luacheck: no unused args
            if c3.selected then
                self.shape_border_color = "#ebdbb2"
            else
                self.shape_border_color = "#665c54"
            end
            if old_wibox then
                old_wibox.cursor = old_cursor
                old_wibox = nil
            end
        end,
    }

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen          = s,
        filter          = awful.widget.taglist.filter.all,
        buttons         = taglist_buttons,
        layout          = {
            layout  = wibox.layout.fixed.vertical,
            spacing = dpi(4),
        },
        widget_template = tag_widget,
    }



    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)
    ))


    s.myBar = wibox {
        height = s.geometry.height - 4 * beautiful.useless_gap,
        -- bg = "#FF0000",
        -- position = "left",
        width = dpi(32),
        -- ontop = true,
        visible = true,
        -- x = s.geometry.x + 2*beautiful.useless_gap,
        x = s.geometry.x + 2 * beautiful.useless_gap,
        y = s.geometry.y + 2 * beautiful.useless_gap,
        screen = s,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, dpi(8))
        end
    }

    -- Add widgets to the wibox
    s.myBar:setup {
        {
            {
                layout = wibox.layout.align.vertical,
                { -- Top widgets
                    layout = wibox.layout.fixed.vertical,
                    -- s.mylayoutbox,
                    s.mytaglist,
                },
                s.mytasklist, -- Middle widget
                { -- Bottom widgets
                    layout = wibox.layout.fixed.vertical,
                    spacing = dpi(6),
                    systray_widget,
                    -- mytextclock,
                    -- clock,
                    clock2,
                },
            },
            widget = wibox.container.margin,
            top = dpi(5),
            bottom = dpi(5),
            left = dpi(4),
            right = dpi(4),
            -- margins = dpi(6),
        },
        widget = wibox.container.background,
        bg = "#3c3836",
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

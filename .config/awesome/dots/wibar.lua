local gears     = require("gears")
local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi


-- Widgets {{{

-- Create a textclock widget
local mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                {raise = true}
            )
        end
    end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(-1)
    end))

local systray = wibox.widget.systray()
systray:set_horizontal(false)
systray:set_base_size(24)
systray.border_width = 3

--}}}

awful.screen.connect_for_each_screen(function(s)

    -- Create a tasklist widget
    local tagtasklist = function (s, tag)
        s.mytasklist = awful.widget.tasklist {
            screen  = s,
            filter  = awful.widget.tasklist.filter.alltags,
            buttons = tasklist_buttons,
            layout   = { layout  = wibox.layout.fixed.vertical, spacing = 4 },
            widget_template = {
                {
                    {
                        layout = wibox.layout.fixed.vertical,
                    },
                    left  = 4,
                    right = 4,
                    widget = wibox.container.margin
                },
                bg = "#00aa00",
                forced_height = 12,
                forced_width = 12,
                widget = wibox.container.background,
                shape = function(cr, width, height)
                    gears.shape.circle(cr, width, height)
                end,
                create_callback = function (self, c, index, objects)
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
        shape_border_width = 2,
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
                self.border_backup     = self.shape_border_color
                self.has_backup = true
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
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        layout   = {
            layout  = wibox.layout.fixed.vertical,
            spacing = 4,
        },
        widget_template = tag_widget,
    }



    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
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
            gears.shape.rounded_rect(cr, width, height, 8)
        end
    }

    -- Add widgets to the wibox
    s.myBar:setup {
        {
            {
                layout = wibox.layout.align.vertical,
                { -- Left widgets
                    layout = wibox.layout.fixed.vertical,
                    s.mytaglist,
                },
                s.mytasklist, -- Middle widget
                { -- Right widgets
                    layout = wibox.layout.fixed.vertical,
                    systray,
                    mytextclock,
                    s.mylayoutbox,
                },
            },
            widget = wibox.container.margin,
            top = 6,
            bottom = 6,
            left = 4,
            right = 4,
            -- margins = 6,
        },
        widget = wibox.container.background,
        bg = "#3c3836",
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 8)
        end,
        shape_border_width = 1,
        shape_border_color = "#504945",
    }

    s.myBar:struts {
        left = s.myBar.width + 2 * beautiful.useless_gap
    }

end)

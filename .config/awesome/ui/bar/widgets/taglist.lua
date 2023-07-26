local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local gears     = require("gears")
local dpi       = require("beautiful.xresources").apply_dpi
local naughty   = require("naughty")

local M = {}

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

local tag_widget = function (s)
  return {
    {
      -- mytasklist(s),
      layout = wibox.layout.fixed.vertical,
    },
    forced_height = dpi(32),
    widget = wibox.container.background,
    bg = "#3c3836",
    shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, dpi(3)) end,
    shape_border_width = dpi(1),
    shape_border_color = "#aa0000",

    -- Add support for hover colors and an index label
    create_callback = function(self, c3, index, objects) --luacheck: no unused args
      if c3.selected then
        self.shape_border_color = "#ebdbb2"
        self.bg = "#665c54"
      else
        self.shape_border_color = "#665c54"
        self.bg = "#3c3836"
      end
      self:connect_signal('mouse::enter', function()
        self.border_backup = self.shape_border_color
        self.bg_backup = self.bg
        self.has_backup    = true
        if not c3.selected then
          self.shape_border_color = '#524F4D'
          self.bg = '#504945'
        end

        local w = mouse.current_wibox
        if w then
          old_cursor, old_wibox = w.cursor, w
          w.cursor = "hand1"
        end

      end)
      self:connect_signal('mouse::leave', function()
        if self.has_backup and not c3.selected then
          self.shape_border_color = self.border_backup
          self.bg = self.bg_backup
        end

        local w = mouse.current_wibox
        if old_wibox then
          old_wibox.cursor = old_cursor
          old_wibox = nil
        end
      end)

    end,

    update_callback = function(self, c3, index, objects) --luacheck: no unused args
      if c3.selected then
        self.shape_border_color = "#7c6f64"
        self.bg = "#665c54"
      else
        self.shape_border_color = "#423e3c"
        self.bg = "#3c3836"
      end
      if old_wibox then
        old_wibox.cursor = old_cursor
        old_wibox = nil
      end
    end,
  }
end


M.taglist = function (s)
  return awful.widget.taglist {
    screen          = s,
    filter          = awful.widget.taglist.filter.all,
    buttons         = taglist_buttons,
    layout          = {
      layout  = wibox.layout.fixed.vertical,
      spacing = dpi(4),
    },
    widget_template = tag_widget(s),
  }
end

local tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    if c == client.focus then c.minimized = true
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
  end)
)

M.tasklist = function(s, tag)
  s.mytasklist = awful.widget.tasklist {
    screen          = s,
    filter          = function (c, s) return c.first_tag == s.selected_tag end,
    buttons         = tasklist_buttons,
    layout          = { layout = wibox.layout.fixed.vertical, spacing = dpi(4) },
    widget_template = {
      {
        {
          {
            id     = "icon_role",
            widget = wibox.widget.imagebox,
          },
          widget = wibox.container.margin,
          margins = 4,
        },
        layout = wibox.layout.fixed.vertical,
      },
      id     = "background_role",
      widget = wibox.container.background,
    },
    -- create_callback = function (self, c, index, objects)
    --     self.filter = function() return c.first_tag == s.selected_tag end
    -- end
  }
  return s.mytasklist
end



return M

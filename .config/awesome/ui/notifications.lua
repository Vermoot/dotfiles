local naughty = require("naughty")
local ruled   = require("ruled")
local awful   = require("awful")
local gears   = require("gears")
local dpi     = require("beautiful.xresources").apply_dpi
local beautiful = require("beautiful")
local wibox = require("wibox")

-- naughty.config.padding = dpi(16)
-- naughty.config.spacing = dpi(8)
-- naughty.config.presets.low.timeout = 5
-- naughty.config.presets.normal.timeout = 6
-- naughty.config.presets.critical.timeout = 12
-- naughty.config.presets.critical.bg = "#aa4444"
naughty.config.defaults.shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, dpi(8))
end
-- naughty.config.defaults.screen = screen.primary
-- naughty.config.defaults.padding = dpi(60)
-- naughty.config.defaults.max_height = dpi(300)
-- naughty.config.defaults.max_width = dpi(400)
-- naughty.config.defaults.icon_size = dpi(64)

ruled.notification.connect_signal('request::rules', function()
  -- All notifications will match this rule.
  ruled.notification.append_rule {
    rule       = {},
    properties = {
      screen           = awful.screen.preferred,
      implicit_timeout = 5,
    }
  }
end)

  naughty.connect_signal("request::display", function(n)
  -- if not n.app_icon then
  --   n.app_icon = beautiful.notification_icon
  -- end

  -- n.title = "<span font='" .. beautiful.font_name .. "10'><b>" .. n.title .. "</b></span>"

  -- local time = os.date "%H:%M"

  naughty.layout.box {
    notification = n,
    type = "notification",
    bg = beautiful.bg_normal,
    widget_template = {
      {
        {
          {
            {
              naughty.widget.icon,
              {
                naughty.widget.title,
                naughty.widget.message,
                spacing = 4,
                layout = wibox.layout.fixed.vertical,
              },
              fill_space = true,
              spacing = 10,
              layout = wibox.layout.fixed.horizontal,
            },
            naughty.list.actions,
            spacing = 10,
            layout = wibox.layout.fixed.vertical,
          },
          margins = 10,
          -- bottom = 10,
          widget = wibox.container.margin,
        },
        id = "background_role",
        widget = naughty.container.background,
      },
      strategy = "max",
      width = 600,
      widget = wibox.container.constraint,
    },
  }
  end)

-- Errors
if awesome.startup_errors then
  naughty.notification({ preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err) })
    in_error = false
  end)
end

-- Imports {{{
-- pcall(require, "luarocks.loader")
-- json = require("json")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local dpi = require("beautiful.xresources").apply_dpi
local beautiful = require("beautiful")
local revelation = require("libs.revelation")
local ruled = require("ruled")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/theme.lua")
revelation.init()
require("awful.autofocus")
require("awful.remote")

local titlebars = require("ui.titlebars")
-- Widget and layout library

-- Theme handling library
--

-- Notification library
local naughty = require("naughty")
-- naughty.config.padding = dpi(16)
-- naughty.config.spacing = dpi(8)
-- naughty.config.presets.low.timeout = 5
-- naughty.config.presets.normal.timeout = 6
-- naughty.config.presets.critical.timeout = 12
-- naughty.config.presets.critical.bg = "#aa4444"
-- naughty.config.defaults.shape = function(cr, width, height)
--     gears.shape.rounded_rect(cr, width, height, dpi(8))
-- end
-- naughty.config.defaults.screen = screen.primary
-- naughty.config.defaults.padding = dpi(30)
-- naughty.config.defaults.max_height = dpi(300)
-- naughty.config.defaults.max_width = dpi(400)
-- naughty.config.defaults.icon_size = dpi(64)
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- local ezconfig = require('libs.ezconfig')
-- package.loaded["naughty.dbus"] = {}

local capi =
{
  mouse = mouse,
  screen = screen,
  client = client,
  awesome = awesome,
  root = root,
}
-- END Imports }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
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
-- }}}

-- DEFAULTS {{{

beautiful.gap_single_client = true

terminal   = "wezterm"
editor     = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
modkey     = "Mod4"
meh        = { "Control", "Shift", "Mod1" }

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.magnifier,
  awful.layout.suit.floating,
}
awful.mouse.snap.edge_enabled = false
awful.mouse.snap.client_enabled = false
-- }}}


local keybinds = require("dots.keybinds")
local volume = require("ui.volume")
local myBar = require("ui.bar")

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
  { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "manual", terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awesome.conffile },
  { "restart", awesome.restart },
  { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
  { "open terminal", terminal }
}
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
  menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Setup

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, false)
  end
end

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)
  -- Each screen has its own tag table.
  awful.tag({ "o", "o", "o", "o", "o", "o", "o" }, s, awful.layout.layouts[1])
end)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
require("rules")
-- }}}

-- {{{ Signals


-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Signal function to execute when a new client appears.
local vst_clients = {}

client.connect_signal("manage", function(c, context)

  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end

  if c.transient_for ~= nil and string.find(c.transient_for.name, "Bitwig") then
    c:emit_signal("request::titlebars")
    -- titlebars.show(c)
    if vst_clients[c.pid] ~= nil then
      c.x = vst_clients[c.pid].x
      c.y = vst_clients[c.pid].y
    end
  end

  local cairo = require("lgi").cairo
  local app_icon = "/home/vermoot/Téléchargements/icons8-application-96.png"
  if c and c.valid and not c.icon then
    local s = gears.surface(app_icon)
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, s:get_width(), s:get_height())
    local cr = cairo.Context(img)
    cr:set_source_surface(s, 0, 0)
    cr:paint()
    c.icon = img._native
  end

end)


client.connect_signal("unmanage", function(c)
  if c.transient_for ~= nil and string.find(c.transient_for.name, "Bitwig") then
    vst_clients[c.pid] = { x = c.x, y = c.y }
  end
end)

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)

-- Focus urgent clients
client.connect_signal("property::urgent", function(c)
  c.minimized = false
  c:jump_to()
end)

client.connect_signal("property::fullscreen", function(c)
  c.screen.bar.ontop = not c.fullscreen
  if c.fullscreen then
    gears.timer.delayed_call(function()
      if c.valid then
        c:geometry(c.screen.geometry)
      end
    end)
  end
end)

client.connect_signal("property::active", function(c)
  c.screen.bar.ontop = not c.fullscreen
end)

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
  naughty.layout.box { notification = n }
end)

-- }}}

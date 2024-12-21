-- pcall(require, "luarocks.loader")
-- json = require("json")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local dpi = require("beautiful.xresources").apply_dpi
local beautiful = require("beautiful")
local naughty = require("naughty")

local revelation = require("libs.revelation")
revelation.init()

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/theme.lua")
require("awful.autofocus")
require("awful.remote")

local capi =
{
  mouse = mouse,
  screen = screen,
  client = client,
  awesome = awesome,
  root = root,
}

local options = require("options")

local titlebars     = require("ui.titlebars")
local volume        = require("ui.volume")
local myBar         = require("ui.bar")
local notifications = require("ui.notifications")
local menu          = require("ui.menu")
-- local resize_borders = require("ui.resize_borders")

local keybinds = require("dots.keybinds")


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

  -- Create a function to draw a circle
  local function create_circle(radius, color)
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, 2 * radius, 2 * radius)
    local cr = cairo.Context(img)

    -- Set the fill color for the circle
    cr:set_source_rgba(color.red, color.green, color.blue, color.alpha)

    -- Draw a circle
    cr:arc(radius, radius, radius, 0, 2 * math.pi)
    cr:fill()

    return img._native
  end

  -- Define the circle's radius and color (change as needed)
  local circle_radius = 16
  local circle_color = { red = 235/255, green = 219/255, blue = 178/255, alpha = 1.0 }

  -- Check if the client (c) is valid and does not have an icon
  if c and c.valid and not c.icon then
    -- Create a circle image and set it as the client's icon
    c.icon = create_circle(circle_radius, circle_color)
  end

end)


client.connect_signal("unmanage", function(c)
  if c.transient_for ~= nil and string.find(c.transient_for.name, "Bitwig") then
    vst_clients[c.pid] = { x = c.x, y = c.y }
  end
end)

kanata_layers = {"firefox", "discord"}
local function set_kanata_layer(layer)
      awful.spawn.with_shell("printf '{\"ChangeLayer\":{\"new\":\"" .. layer .. "\"}}\n' | nc -w1 127.0.0.1 10000")
end

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
  -- naughty.notify({title="Focus: " .. c.class})

  for k, v in pairs(kanata_layers) do
    if v == c.class then
      set_kanata_layer(c.class)
      break
    end
    set_kanata_layer("default")
  end

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

-- }}}

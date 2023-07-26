-- Imports {{{
pcall(require, "luarocks.loader")
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

local titlebars = require("UI.titlebars")
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
local volume = require("UI.volume")
local myBar = require("UI.bar")

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

  -- s.padding = { top = 8, bottom = 8, left = 8, right = 8}

end)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      maximized_horizontal = false,
      maximized_vertical = false,
      maximized = false,
      size_hints_honor = true,
    }
  },

  -- Fullscreen
  -- { rule = { fullscreen = true },
  -- callback = function (c)
  --   gears.timer.delayed_call(function()
  --     if c.valid then
  --       c:geometry(c.screen.geometry)
  --     end
  --   end)
  -- end
  -- },

  -- Floating but not transient
  { rule = { floating = true, transient_for = nil },
    except_any = { type = "splash", "dock", "desktop" },
    properties = {},
    callback = function(c)
      if c.transient_for ~= nil and c.class ~= "plasmashell" then
        awful.placement.centered(c, { parent = c.transient_for })
        awful.placement.no_offscreen(c)
        c:emit_signal("request::titlebars")
      elseif c.size_hints ~= nil then
        c.size_hints.program_position = nil
        local s = c.screen
        if c.size_hints.program_position ~= nil and c.size_hints.program_position.x ~= 0 then
          c.x = c.size_hints.program_position.x
          c.y = c.size_hints.program_position.y
        elseif c.size_hints.user_position ~= nil and c.size_hints.user_position.x ~= 0 then
          c.x = c.size_hints.user_position.x
          c.y = c.size_hints.user_position.y
        end
        c.screen = s
      else
        awful.placement.centered(c)
        awful.placement.no_offscreen(c)
      end
    end

  },

  -- -- Floating and transient
  -- { rule   = { floating = true },
  --   except = { transient_for = nil},
  --   callback = function (c)
  --       naughty.notify({
  --         title = "Floating and transient",
  --         text = c.name .. c.transient_for.name
  --       })
  --       awful.placement.centered(c, { parent = c.transient_for })
  --       awful.placement.no_offscreen(c)
  --   end,
  --   properties = { titlebars_enabled = true }
  -- },

  { rule = { class = "firefox" },
    properties = {
      keys = gears.table.join(clientkeys, firefox_keys),
      buttons = gears.table.join(clientbuttons, firefox_buttons)
    }
  },

  { rule_any = { class = { "discord", "WebCord" } },
    properties = { keys = gears.table.join(clientkeys, discord_keys), }
  },

  { rule = { name = "Picture-in-Picture" },
    properties = { sticky = true, ontop = true }
  },


  -- Floating clients.
  { rule_any = {
    instance = {},
    class = {
      "1Password",
    },
    name = {
      "Event Tester", -- xev.
      "Liste de contacts", -- steam friends
      "Plover: SVG Layout Display",
    },
    role = {}
  }, properties = { floating = true } },

  { rule = { name = "Plover: SVG Layout Display" },
    properties = { border_width = 0 }
  },

  { rule = { class = "fusion360.exe" },
    properties = {
      sticky = false,
    },
  },

  { rule = { class = "fusion360.exe", type = "dialog" },
    properties = {
      border_width = 0,
    },
  },

  { rule = { class = "fusion360.exe" },
    except = { transient_for = nil },
    properties = {
      sticky = false
    },
  },

  -- Add titlebars to default-to-floating clients
  -- { rule = {floating = true, class = nil,}, except = {class = "yabridge-host.exe.so"},
  -- properties = { titlebars_enabled = true, focusable = false }
  -- },

  { rule = { class = "yabridge-host.exe.so" },
    properties = { border_width = 0, focusable = false }
  },

  { rule = { class = "yabridge-host.exe.so" },
    except = { name = "menu" },
    properties = { hidden = true },
  },

  -- Case-by-case basis
  { rule = { name = "plank" }, properties = { ontop = true } },
  { rule = { class = "eww" }, properties = { focusable = false, border_width = 0 } },
  { rule = { class = "tint2" }, properties = { border_width = 0 } },
  { rule = { class = "albert", type = "utility" }, properties = { border_width = 0 } },
  { rule = { name = "xfce4-panel" }, properties = { ontop = true } },
  -- { rule_any = { name =  { "menu"        } }, properties = { border_width=4 } },
  { rule = { class = "floatingfeh" }, properties = { floating = true,
    placement = awful.placement.centered() } },
  { rule = { name = "Untapped.gg Overlay" },
    properties = { floating = true, border_width = 0, focusable = false, ontop = true } },

  -- Plasma Stuff {{{
  -- { rule = { class = "plasmashell" },
  --   properties = { border_width = 1, placement = awful.placement.centered(), },
  --   callback = function(c)
  --   end
  -- },

  {
    rule       = {
      class = "plasmashell",
      type  = "desktop" },
    properties = {
      floating          = true,
      below             = true,
      border_width      = 0,
      sticky            = true,
      focusable         = true,
      titlebars_enabled = false,
    },
    callback = function(c)
      c:geometry(c.screen.geometry)
      c:lower()
    end,
  },
  { rule_any = { class = { "krunner" } }, properties = { floating = true } },
  { rule = { class = "lattedock", type = "dock" },
    properties = { border_width = 0 } },
  -- { rule = { class = "plasmashell" },
  --   properties = { honor_workarea = false }
  -- },

  -- -- Panels
  { rule = { class = "plasmashell", type = "dock" },
    properties = {
      border_width = 0, focusable = false
    }
  },

  -- Dialogs (menus)
  { rule = { class = "plasmashell", type = "dialog" },
    properties = {
      floating = true,
      border_width = 1,
      sticky = true,
      focusable = true,
    }
  },

  -- OSDs (Volume...)
  { rule = { class = "plasmashell", type = "notification" },
    properties = {
      floating = true,
      focusable = false,
      border_width = 5,
    }
  },
  -- END Plasma Stuff }}}

}
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

  -- if not c.fullscreen then
  --   c.shape = function(cr,w,h)
  --         gears.shape.rounded_rect(cr,w,h,12)
  --   end
  -- end
  --
  -- if c.fullscreen then
  --   gears.timer.delayed_call(function()
  --     if c.valid then
  --       c:geometry(c.screen.geometry)
  --     end
  --   end)
  -- end

  -- if c.floating then
  --   -- awful.titlebar.show(c, titlebar_position(c))
  --   -- c:emit_signal("request::titlebars")
  --   for _, type in ipairs({"splash", "dock", "desktop"}) do
  --     if c.type == type then
  --       return
  --     end
  --   end
  --   if c.class == "plasmashell" then
  --     -- c.x = c.size_hints.user_position.x
  --     -- c.y = c.size_hints.user_position.y
  --     -- c.border_width = 1
  --     -- awful.placement.no_offscreen(c)
  --     return
  --   end
  --   if c.transient_for == nil and c.class ~= "yabridge-host.ex" then
  --     awful.placement.centered(c)
  --   else
  --     titlebars.show(c)
  --     awful.placement.centered(c, { parent = c.transient_for })
  --   end
  --   awful.placement.no_offscreen(c)
  -- end

  if c.transient_for ~= nil and string.find(c.transient_for.name, "Bitwig") then

    c:emit_signal("request::titlebars")
    -- titlebars.show(c)
    if vst_clients[c.pid] ~= nil then
      c.x = vst_clients[c.pid].x
      c.y = vst_clients[c.pid].y
    end

  end

  -- local r, g, b = color.utils.hex_to_rgba(c.border_color)
  -- local r_timed = rubato.timed {duration=0.2, pos=r}
  -- local g_timed = rubato.timed {duration=0.2, pos=g}
  -- local b_timed = rubato.timed {duration=0.2, pos=b}
  --
  -- local function update_border_color ()
  --   if c ~= nil then
  --     c.border_color = "#"..color.utils.rgba_to_hex {
  --       math.max(r_timed.pos, 0),
  --       math.max(g_timed.pos, 0),
  --       math.max(b_timed.pos, 0)
  --     }
  --   end
  -- end
  --
  -- r_timed:subscribe(update_border_color)
  -- g_timed:subscribe(update_border_color)
  -- b_timed:subscribe(update_border_color)
  --
  -- awful.client.property.set(c, "set_border_color",  function(new_color)
  --   r_timed.target, g_timed.target, b_timed.target = color.utils.hex_to_rgba(new_color)
  -- end)

end)


client.connect_signal("unmanage", function(c)
  if c.transient_for ~= nil and string.find(c.transient_for.name, "Bitwig") then
    vst_clients[c.pid] = { x = c.x, y = c.y }
  end
end)



-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
-- c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)




client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
  -- c.set_border_color(beautiful.border_focus)
  -- awful.client.property.get(c, "set_border_color")(beautiful.border_focus)
end)

client.connect_signal("unfocus", function(c)
  -- c.set_border_color(beautiful.border_normal)
  -- awful.client.property.get(c, "set_border_color")(beautiful.border_normal)
  c.border_color = beautiful.border_normal
end)


-- Focus urgent clients
client.connect_signal("property::urgent", function(c)
  c.minimized = false
  c:jump_to()
end)

client.connect_signal("property::fullscreen", function(c)
  c.screen.myBar.ontop = not c.fullscreen
  if c.fullscreen then
    gears.timer.delayed_call(function()
      if c.valid then
        c:geometry(c.screen.geometry)
      end
    end)
  end
end)

client.connect_signal("property::active", function(c)
  c.screen.myBar.ontop = not c.fullscreen
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
  -- naughty.notify({ title = "yo" })
  naughty.layout.box { notification = n }
end)

-- }}}

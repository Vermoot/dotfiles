-- Imports {{{
pcall(require, "luarocks.loader")
-- json = require("json")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local gmath = require("gears.math")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi
local rubato = require("libs.rubato")
local color = require("libs.color")
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/theme.lua")
require("awful.autofocus")
require("awful.remote")

local titlebars = require("dots.titlebars")
-- Widget and layout library

-- Theme handling library
--

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- local ezconfig = require('libs.ezconfig')
package.loaded["naughty.dbus"] = {}

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
  naughty.notify({ preset = naughty.config.presets.critical,
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
local volume = require("dots.volume")
local myBar = require("dots.wibar")
-- local resize_borders = require("dots.resize_borders")

-- Bar function {{{

--[[
   [ local function update_state (noti)
   [ 
   [     local wm_state = {}
   [ 
   [     for s in screen do
   [         this_screen = {}
   [         for _, t in ipairs(s.tags) do
   [             this_tag = {index=t.index, name=t.name, visible=t.selected, clients={}}
   [             for _,c in ipairs(s:get_all_clients(false)) do
   [                 -- if c.type == "normal" then
   [             -- for _, c in ipairs(client.get(0, true)) do
   [                 if (c.type == "normal" or c.type == "dialog") and c.first_tag == t then
   [                     table.insert(this_tag["clients"], {name=c.name,
   [                                                        id=c.window,
   [                                                        class=c.class,
   [                                                        focused = c == client.focus,
   [                                                        minimized=c.minimized,
   [                                                        maximized=c.maximized,
   [                                                        floating=c.floating,
   [                                                        oncurrenttag = c:isvisible()})
   [                 end
   [             end
   [             table.insert(this_screen, this_tag)
   [         end
   [         table.insert(wm_state, this_screen)
   [     end
   [     json_wm_state = json.encode(wm_state)
   [     -- This is janky as shit, but single quotes in client names trip everything up.
   [     -- Maybe find a solution one day.
   [     json_wm_state = json_wm_state:gsub("'", "")
   [     awful.spawn.with_shell("eww update wm_state='"..json_wm_state.."'")
   [     awful.spawn.with_shell("echo '"..json_wm_state.."' > ~/.config/eww/wm_state_example.json")
   [ 
   [     if noti then
   [         awful.util.spawn("notify-send '" .. json_wm_state .. "'")
   [         awful.spawn.with_shell("echo '"..json_wm_state.."' | xsel -b")
   [     end
   [ end
   [ 
   [ client.connect_signal("focus", function () update_state() end)
   [ client.connect_signal("property::position", function () update_state() end)
   [ client.connect_signal("list", function () update_state() end)
   [ client.connect_signal("request::geometry", function () update_state() end)
   [ client.connect_signal("unfocus", function () update_state() end)
   [ screen.connect_signal("tag::history::update", function () update_state() end)
   ]]


--}}}

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
    gears.wallpaper.maximized(wallpaper, s, true)
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
    }
  },

  { rule = { class = "firefox" },
    properties = {
      keys = gears.table.join(clientkeys, firefox_keys),
      buttons = gears.table.join(clientbuttons, firefox_buttons)
    }
  },

  { rule = { class = "discord" },
    properties = { keys = gears.table.join(clientkeys, discord_keys), }
  },

  { rule = { name = "Picture-in-Picture" },
    properties = { sticky = true, ontop = true }
  },

  { rule = { class = "trayer" },
    properties = { ontop = true, border_width = 0 }
  },

  --[[
      [ { rule = { class = "wezterm" },
      [    properties = { titlebars_enabled = true }
      [ },
      ]]

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

  -- Add titlebars to default-to-floating clients
  -- { rule = {floating = true, class = nil,}, except = {class = "yabridge-host.exe.so"},
  -- properties = { titlebars_enabled = true, focusable = false }
  -- },

  { rule = { class = { "yabridge-host.exe.so" } },
    properties = { border_width = 0 }
  },

  -- Case-by-case basis
  { rule_any = { name = { "plank" } }, properties = { ontop = true } },
  { rule_any = { class = { "eww" } }, properties = { border_width = 0 } },
  { rule_any = { class = { "tint2" } }, properties = { border_width = 0 } },
  { rule_any = { name = { "xfce4-panel" } }, properties = { ontop = true } },
  -- { rule_any = { name =  { "menu"        } }, properties = { border_width=4 } },
  { rule_any = { class = { "floatingfeh" } }, properties = { floating = true,
    placement = awful.placement.centered() } },
  -- Plasma Stuff {{{
  -- Desktop
  {
    rule       = { class = "plasmashell", type = "desktop" },
    properties = { floating = true, border_width = 0, sticky = true, focusable = true, titlebars_enabled = false, },
    callback   = function(c)
      c:geometry({ width = 1920, height = 1080, x = 0, y = 0 })
    end,
  },
  { rule_any = { class = { "krunner" } }, properties = { floating = true } },
  { rule_any = { class = { "latte-dock" } }, properties = { floating = true, border_width = 0, sticky = true } },

  -- Panels
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

  { rule = { class = "eww" }, properties = { focusable = false, } },

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

  if c.fullscreen then
    gears.timer.delayed_call(function()
      if c.valid then
        c:geometry(c.screen.geometry)
      end
    end)
  end

  if c.floating then
    -- awful.titlebar.show(c, titlebar_position(c))
    -- c:emit_signal("request::titlebars")
    for _, type in ipairs({"splash", "dock", "desktop"}) do
      if c.type == type then
        return
      end
    end
    titlebars.show(c)
    if c.transient_for == nil then
      awful.placement.centered(c)
    else
      awful.placement.centered(c, { parent = c.transient_for })
    end
    awful.placement.no_offscreen(c)
  end

  if c.transient_for ~= nil and string.find(c.transient_for.name, "Bitwig") then

    -- c:emit_signal("request::titlebars")
    titlebars.show(c)
    if vst_clients[c.pid] ~= nil then
      c.x = vst_clients[c.pid].x
      c.y = vst_clients[c.pid].y
    end

  end

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
end)

client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)
-- client.connect_signal("property::geometry", function(c)
-- if awful.titlebar(c) ~= nil then
-- if c.height >= c.width then
-- awful.titlebar.hide(c, "top")
-- awful.titlebar.show(c, "left")
-- else
-- awful.titlebar.hide(c, "left")
-- awful.titlebar.show(c, "top")
-- end
-- end
-- end)

-- Focus firefox when clicking on a link
client.connect_signal("property::urgent", function(c)
  -- if c.class == "firefox" then
  -- c.minimized = false
  -- c:jump_to()
  -- end
  c.minimized = false
  c:jump_to()
end)

-- }}}

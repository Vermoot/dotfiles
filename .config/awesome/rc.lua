-- Imports {{{
pcall(require, "luarocks.loader")
json = require("json")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local gmath = require("gears.math")
require("awful.autofocus")
require("awful.remote")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
--
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local ezconfig = require('ezconfig')
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
    awesome.connect_signal("debug::error", function (err)
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
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/zenburn/theme.lua")

-- local nice = require("nice")
-- nice()

beautiful.gap_single_client = true

terminal = "wezterm"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"
-- meh = "Control, Shift, Mod1"
meh = { "Control", "Shift", "Mod1" }

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating,
}
awful.mouse.snap.edge_enabled = false
awful.mouse.snap.client_enabled = false
-- }}}

-- Bar function {{{

local function update_state (noti)

    local wm_state = {}

    for s in screen do
        this_screen = {}
        for _, t in ipairs(s.tags) do
            this_tag = {index=t.index, name=t.name, visible=t.selected, clients={}}
            for _,c in ipairs(s:get_all_clients(false)) do
                -- if c.type == "normal" then
            -- for _, c in ipairs(client.get(0, true)) do
                if (c.type == "normal" or c.type == "dialog") and c.first_tag == t then
                    table.insert(this_tag["clients"], {name=c.name,
                                                       id=c.window,
                                                       class=c.class,
                                                       focused = c == client.focus,
                                                       minimized=c.minimized,
                                                       maximized=c.maximized,
                                                       floating=c.floating,
                                                       oncurrenttag = c:isvisible()})
                end
            end
            table.insert(this_screen, this_tag)
        end
        table.insert(wm_state, this_screen)
    end
    -- awful.spawn.with_shell("notify-send 'update_state'")
    awful.spawn.with_shell("eww update wm_state='"..json.encode(wm_state).."'")
    awful.spawn.with_shell("echo '"..json.encode(wm_state).."' > ~/.config/eww/wm_state_example.json")

    if noti then
        awful.util.spawn("notify-send '" .. json.encode(wm_state) .. "'")
        awful.spawn.with_shell("echo '"..json.encode(wm_state).."' | xsel -b")
    end
end

client.connect_signal("focus", function () update_state() end)
client.connect_signal("property::position", function () update_state() end)
client.connect_signal("list", function () update_state() end)
client.connect_signal("request::geometry", function () update_state() end)
client.connect_signal("unfocus", function () update_state() end)
screen.connect_signal("tag::history::update", function () update_state() end)


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

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

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
                                          end)
                    -- awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
                    -- awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
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
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

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
    awful.tag({ "o", "o", "o", "o", "o", "o", "o"}, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
    }

--[[
   [     -- Create the wibox
   [     s.mywibox = awful.wibar({ position = "top", screen = s})
   [ 
   [     -- Add widgets to the wibox
   [     s.mywibox:setup {
   [         layout = wibox.layout.align.horizontal,
   [         { -- Left widgets
   [             layout = wibox.layout.fixed.horizontal,
   [             -- mylauncher,
   [             s.mytaglist,
   [             s.mypromptbox,
   [         },
   [         s.mytasklist, -- Middle widget
   [         { -- Right widgets
   [             layout = wibox.layout.fixed.horizontal,
   [             wibox.widget.systray(),
   [             mytextclock,
   [             s.mylayoutbox,
   [         },
   [     }
   ]]
end)
-- }}}

-- {{{ Mouse bindings
clientbuttons = gears.table.join(
    awful.button({ }, 1, function(c)
            if c.focusable then
                client.focus = c
                c:raise()
            end

            if not c.floating then
                return
            end

            -- Only use bottom left/right corner, because dragging titlebar is already mapped to move
            local corners = {
                -- { c.x,           c.y },            -- Top Left
                { c.x + c.width, c.y },            -- Top Right
                -- { c.x,           c.y + c.height }, -- Bottom Left
                { c.x + c.width, c.y + c.height }, -- Bottom Right
            }

            local m = mouse.coords()
            local distance = 20

            for _, pos in ipairs(corners) do
                if math.sqrt((m.x - pos[1]) ^ 2 + (m.y - pos[2]) ^ 2) <= distance then
                    awful.mouse.client.resize(c)
                    break
                -- elseif math.sqrt((m.x - c.x) ^ 2) <= distance then
                    -- awful.mouse.client.resize(c)
                end
            end
        end),
        -- awful.button({ }, 1, function (c)
        --     c:emit_signal("request::activate", "mouse_click", {raise = true})
        -- end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end),
    awful.button({}, 14, function () awful.tag.viewnext() end),
    awful.button({}, 15, function () awful.tag.viewprev() end)
)

root.buttons(gears.table.join(
    -- clientbuttons,
    awful.button({ }, 3, function () mymainmenu:toggle() end)
))

firefox_buttons = gears.table.join(
    awful.button({}, 10, function () awful.util.spawn("xdotool key --clearmodifiers Ctrl+Tab") end),
    awful.button({}, 11, function () awful.util.spawn("xdotool key --clearmodifiers Ctrl+Shift+Tab") end),
    awful.button({}, 13, function () awful.util.spawn("xdotool key --clearmodifiers Ctrl+w") end),
    awful.button({}, 12, function () awful.util.spawn("xdotool key --clearmodifiers Ctrl+Shift+t") end)
)

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

-- }}}

-- {{{ Key bindings

-- Functions {{{
local function noti_type()
    local c = client.focus
    awful.util.spawn("notify-send -t 0 '"..c.name..c.type.."'" )
end

local function move_to_previous_tag()
    local c = client.focus
    if not c then return end
    local t = c.screen.selected_tag
    local tags = c.screen.tags
    local idx = t.index
    local newtag = tags[gmath.cycle(#tags, idx - 1)]
    c:move_to_tag(newtag)
    awful.tag.viewprev()
end

local function move_to_next_tag()
    local c = client.focus
    if not c then return end
    local t = c.screen.selected_tag
    local tags = c.screen.tags
    local idx = t.index
    local newtag = tags[gmath.cycle(#tags, idx + 1)]
    c:move_to_tag(newtag)
    awful.tag.viewnext()
end

local function swap_screens()
    local s = awful.screen.focused()
    local t  = s.selected_tag
    local t2 = screen[gmath.cycle(screen.instances(), s.index + 1)].selected_tag
    t:swap(t2)
    -- awful.screen.focus_relative(1)
end

local function next_screen()
    local s = awful.screen.focused()
    local s2 = screen[gmath.cycle(screen.instances(), s.index + 1)]
    s2.selected_tag:clients()[0]:raise()
end

local function swap_tag_by_idx(idx)
    local t = client.focus.screen.selected_tag
    local tags = awful.screen.focused().tags
    local nt = tags[gmath.cycle(#tags, t.index-idx)]
    t:swap(nt)
    update_state()
end

local function toggle_gaps()
    local t = awful.screen.focused().selected_tag
    if t.gap == beautiful.useless_gap then
        t.gap = 0
    else
        t.gap = beautiful.useless_gap
    end
end

local function close_tag()
    local t = awful.screen.focused().selected_tag
    if not t then return end
    t:delete()
end
-- END Functions }}}

globalkeys = gears.table.join(

    -- Move across tags
    awful.key({ modkey,           }, "e",      awful.tag.viewprev),
    awful.key({ modkey,           }, "n",      awful.tag.viewnext),

    awful.key({ modkey, "Mod1"    }, "o",      function () swap_screens() end),
    awful.key({ modkey,           }, "k",      function () update_state(true) end),
    awful.key({ modkey,           }, "j",      function () noti_type() end),

    awful.key({ modkey,           }, "i",      function () awful.client.focus.byidx( 1)   end),
    awful.key({ modkey,           }, "m",      function () awful.client.focus.byidx(-1)   end),
    
    awful.key({ modkey,           }, "t",      function () awful.tag.add("o", { screen = awful.screen.focused(),
                                                                                layout = awful.layout.suit.tile
                                                                              }
                                                                        ):view_only()   end),
    awful.key({ modkey,           }, "w",      function () close_tag() end),

    -- Layout manipulation
    awful.key({ modkey, "Control" }, "i",      function () awful.client.swap.byidx( 1)    end),
    awful.key({ modkey, "Control" }, "m",      function () awful.client.swap.byidx(-1)    end),
    awful.key({ modkey, "Control" }, "e",      function () move_to_previous_tag()         end),
    awful.key({ modkey, "Control" }, "n",      function () move_to_next_tag()             end),
    awful.key({ modkey, "Mod1"    }, "n",      function () swap_tag_by_idx(-1)                end),
    awful.key({ modkey, "Mod1"    }, "e",      function () swap_tag_by_idx(1)                end),
    awful.key({ modkey,           }, "o",      function () awful.screen.focus_relative(1) end),
    awful.key({ modkey,           }, "g",      function () toggle_gaps() end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r",      awesome.restart),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit),
    awful.key({ modkey,           }, "Right",  function () awful.tag.incmwfact( 0.1)           end),
    awful.key({ modkey,           }, "Left",   function () awful.tag.incmwfact(-0.1)           end),
    awful.key({ modkey,           }, "Up",     function () awful.client.incwfact( 0.1)         end),
    awful.key({ modkey,           }, "Down",   function () awful.client.incwfact(-0.1)         end),
    awful.key({ modkey,           }, ",",      function () awful.tag.incnmaster( 1, nil, true) end),
    awful.key({ modkey,           }, ".",      function () awful.tag.incnmaster(-1, nil, true) end),
    awful.key({ modkey, "Control" }, ",",      function () awful.tag.incncol( 1, nil, true)    end),
    awful.key({ modkey, "Control" }, ".",      function () awful.tag.incncol(-1, nil, true)    end),
    awful.key({ modkey,           }, "d",      function () awful.layout.inc( 1)                end),


    -- Volume keys
    awful.key({}, "XF86AudioRaiseVolume", function () awful.spawn.with_shell("pamixer -i 5 --unmute && volume.sh",    false) end),
    awful.key({}, "XF86AudioLowerVolume", function () awful.spawn.with_shell("pamixer -d 5 --unmute && volume.sh",    false) end),
    awful.key({}, "XF86AudioMute",        function () awful.spawn.with_shell("pamixer -t && volume.sh",        false) end),

    -- Media keys
    awful.key({}, "XF86AudioPlay",        function () awful.util.spawn("playerctl -p spotify play-pause", false) end),
    awful.key({}, "XF86AudioRewind",      function () awful.util.spawn("playerctl -p spotify previous",   false) end),
    awful.key({}, "XF86AudioForward",     function () awful.util.spawn("playerctl -p spotify next",       false) end),

    -- Utils
    awful.key({ modkey, }, "space", function () awful.util.spawn("rofi -m -4 -combi-modi 'window,drun' -show combi -modi combi",                                     false) end),
    awful.key({ modkey,  }, "s",     function () awful.spawn.with_shell("scrot -s -f -b ~/scrot.png && xclip -selection clipboard -t image/png ~/scrot.png && rm ~/scrot.png",    false) end),
    awful.key({ modkey,  }, "r",     function () awful.spawn.with_shell("replay-sorcery save",    false) end),
    awful.key({ modkey, "Control"  }, "space",     function () awful.spawn.with_shell("~/.config/eww/modules/menu/menu.sh",    false) end)
    -- awful.key({ modkey,  }, "r",     function () awful.spawn.with_shell("scrot -s -b ~/scrot.png && xclip -selection clipboard -t image/png ~/scrot.png && rm ~/scrot.png", false) end)

)

clientkeys = gears.table.join(
    -- awful.key({ modkey,           }, 'b', awful.titlebar.toggle),
    awful.key({ modkey,           }, 'b',
        function (c)
            awful.titlebar.toggle(c, "left")
        end),
    awful.key({ modkey,           }, "c", function (c) c:kill()                         end),
    awful.key({ modkey,           }, "f",
        function(c)
            if c.floating then
                c.floating = false
                awful.titlebar.hide(c, "left")
            else
                c.floating = true
                awful.titlebar.show(c, "left")
                c:geometry({width=1200, height=700})
                awful.placement.centered(c)
            end
        end),
    awful.key({ modkey,           }, "y", function (c) c.ontop = not c.ontop                         end),
    awful.key({ modkey, "Control" }, "l", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, "Control" }, "o", function (c) c:move_to_screen()               end),
    awful.key({ modkey,           }, "x", function (c) c.maximized = not c.maximized c:raise() end)
)


local function xdotool(combination)
    return awful.util.spawn("xdotool key --clearmodifiers" .. combination)
end

firefox_keys = gears.table.join(
    awful.key(meh, "n", function (c) awful.util.spawn("xdotool key --clearmodifiers Control+Tab") end),
    awful.key(meh, "e", function (c) awful.util.spawn("xdotool key --clearmodifiers Control+Shift+Tab") end),

    --Not possible right now because meh+ctrl isn't a thing. Make meh right side mods to have multiple ctrl?
    awful.key(meh, "Control", "e", function (c) awful.util.spawn("xdotool key --clearmodifiers Control+Shift+Prior") end),
    awful.key(meh, "Control", "n", function (c) awful.util.spawn("xdotool key --clearmodifiers Control+Shift+Next") end)
)

discord_keys = gears.table.join(
    awful.key(meh, "n", function (c) awful.util.spawn("xdotool key --clearmodifiers Alt+Down") end),
    awful.key(meh, "e", function (c) awful.util.spawn("xdotool key --clearmodifiers Alt+Up") end),

    awful.key(meh, "Down", function (c) awful.util.spawn("xdotool key --clearmodifiers Alt+Shift+Down") end),
    awful.key(meh, "Up", function (c) awful.util.spawn("xdotool key --clearmodifiers Alt+Shift+Up") end),

    awful.key(meh, "m", function (c) awful.util.spawn("xdotool key --clearmodifiers Control+Alt+Down") end),
    awful.key(meh, "i", function (c) awful.util.spawn("xdotool key --clearmodifiers Control+Alt+Up") end)
)


-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     maximized_horizontal = false,
                     maximized_vertical = false,
                     maximized = false,
                   }
    },

    { rule = {class = "firefox"},
      properties = { keys = gears.table.join(clientkeys, firefox_keys),
                     buttons = gears.table.join(clientbuttons, firefox_buttons)}
    },

    { rule = {class = "discord"},
      properties = { keys = gears.table.join(clientkeys, discord_keys),}
    },

    -- Floating clients.
    { rule_any = {
        instance = { },
        class = {
          "1Password",
         },
        name = {
          "Event Tester",  -- xev.
          "Liste de contacts",  -- steam friends
        },
        role = { }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Case-by-case basis
    { rule_any = { name = { "plank" } }, properties = { ontop = true } },
    { rule_any = { class = { "eww" } }, properties = { border_width=0 } },
    { rule_any = { class = { "tint2" } }, properties = { border_width=0 } },
    { rule_any = { name = { "xfce4-panel" } }, properties = { ontop = true } },
    { rule_any = { name = { "menu" } }, properties = { border_width=0 } },
    { rule_any = { class = { "floatingfeh" } }, properties = { floating = true,
                                                               placement = awful.placement.centered() } },

    --[[
       [ -- Plasma stuff
       [ { rule_any = {
       [     role = {
       [         "pop-up",
       [         "task_dialog",
       [     },
       [     name = {
       [         "win7",
       [     },
       [     class = {
       [         "plasmashell",
       [         "Plasma",
       [         "krunner",
       [         "Kmix",
       [         "Klipper",
       [         "Plasmoidviewer",
       [     },
       [ }
       [ , properties = {
       [     floating = true,
       [     border_width = 1,
       [     sticky = true,
       [     -- focusable = false
       [     },
       [     -- role = { "dock" }
       [ },
       ]]

    -- Desktop
    {
        rule       = { class = "plasmashell", type = "desktop" },
        properties = { floating = true, border_width=0, sticky=true, focusable=true },
        callback   = function(c)
                        c:geometry( { width = 1920 , height = 1080 } )
                     end,
    },
    { rule_any = { class = { "krunner" } }, properties = { floating=true } },
    { rule_any = { class = { "latte-dock" } }, properties = { floating=true, border_width=0, sticky=true } },

    -- Panels
    { rule = {class = "plasmashell", type = "dock"},
        properties = {
            border_width = 0, focusable = false
        }
    },

    -- Dialogs (menus)
    { rule = {class = "plasmashell", type = "dialog"},
        properties = {
            floating = true,
            border_width = 1,
            sticky = true,
            focusable = true,
        }
    },

    -- OSDs (Volume...)
    { rule = {class = "plasmashell", type = "notification"},
        properties = {
            floating = true,
            focusable = false,
            border_width = 5,
        }
    },
    
    {rule = {class = "eww"}, properties = {focusable = false,}},

    {rule = {class = "yabridge-host.exe.so"},
        properties = {
            border_width = 0,
        }
    },
}
-- }}}

-- {{{ Signals


-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
    
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
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

    awful.titlebar(c, { position="left", size = 32}) : setup
    {
        { -- Top
            {
                awful.titlebar.widget.closebutton    (c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.minimizebutton(c),
                spacing = 6,
                layout = wibox.layout.fixed.vertical,
            },
            margins = 8,
            widget = wibox.container.margin
        },
        {
            buttons = buttons,
            widget = wibox.layout.flex.vertical
        },
        --[[
           [ { -- Bottom
           [     {
           [         awful.titlebar.widget.iconwidget(c),
           [         buttons = buttons,
           [         layout  = wibox.layout.fixed.vertical(),
           [     },
           [     margins = 7,
           [     widget = wibox.container.margin
           [ },
           ]]
        --[[
           [ { -- Middle
           [     { -- Title
           [         align  = "center",
           [         widget = awful.titlebar.widget.titlewidget(c)
           [     },
           [     margins = 4,
           [     widget = wibox.container.margin,
           [     buttons = buttons,
           [     layout  = wibox.layout.flex.vertical
           [ },
           ]]
        layout = wibox.layout.align.vertical
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
    -- c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

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

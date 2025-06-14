-- Imports {{{
local gears = require("gears")
local gmath = require("gears.math")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local naughty = require("naughty")
local volume = require("ui.volume")
local titlebars = require("ui.titlebars")
-- local revelation = require("libs.revelation")
-- END Imports }}}

local menu = require("ui.clientmenu")

-- Functions {{{
local function noti_type()
    local c = mouse.current_client
    naughty.notify({title = "Class", text=c.class})
    naughty.notify({title = "Name", text=c.name})
    naughty.notify({title = "Type", text=c.type})
    naughty.notify({title = "Transient for", text=c.transient_for ~= nil and c.transient_for.name or "nil"})
end

local function list_clients_tag()
    for _, c in ipairs(awful.screen.focused().selected_tag:clients()) do
        naughty.notify({title = c.name, text="class = " .. c.class .."\ntype = " .. c.type})
    end
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
    local s  = awful.screen.focused()
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
    local nt = tags[gmath.cycle(#tags, t.index - idx)]
    t:swap(nt)
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

-- Keybinds {{{
local gui = "Mod4"
local alt = "Mod1"
local ctl = "Control"
local sft = "Shift"

globalkeys = gears.table.join(

    -- awful.key({ modkey, "Control"}, "space", function()
    --     -- if mouse.current_client.class == "firefox" the
    --     --     awful.spawn.with_shell("kando -m Firefox")
    --     -- else
    --     --     awful.spawn.with_shell("kando -m default")
    --     -- end
    --     awful.spawn.with_shell("kando -m " .. mouse.current_client.class)
    -- end),
-- Move across tags
    awful.key({ modkey, }, "e", awful.tag.viewprev),
    awful.key({ modkey, }, "n", awful.tag.viewnext),
    -- awful.key({ modkey, }, "k", revelation),

    awful.key({ modkey, "Mod1" }, "o", function() swap_screens() end),
    awful.key({ modkey, }, "j", function() noti_type() end),
    awful.key({ modkey, "Shift" }, "j", function() list_clients_tag() end),

    awful.key({ modkey, }, "i", function() awful.client.focus.byidx(1) end),
    awful.key({ modkey, }, "m", function() awful.client.focus.byidx(-1) end),

    awful.key({ modkey, }, "t", function() awful.tag.add("o", { screen = awful.screen.focused(),
            layout = awful.layout.suit.tile
        }
        ):view_only()
    end),
    awful.key({ modkey, }, "w", function() close_tag() end),

    -- Layout manipulation
    awful.key({ modkey, "Control" }, "i", function() awful.client.swap.byidx(1) end),
    awful.key({ modkey, "Control" }, "m", function() awful.client.swap.byidx(-1) end),
    awful.key({ modkey, "Control" }, "e", function() move_to_previous_tag() end),
    awful.key({ modkey, "Control" }, "n", function() move_to_next_tag() end),
    awful.key({ modkey, "Mod1" }, "n", function() swap_tag_by_idx(-1) end),
    awful.key({ modkey, "Mod1" }, "e", function() swap_tag_by_idx(1) end),
    awful.key({ modkey, }, "o", function() awful.screen.focus_relative(1) end),
    awful.key({ modkey, }, "g", function() toggle_gaps() end),

    -- Standard program
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift" }, "q", awesome.quit),
    awful.key({ modkey, }, "Right", function() awful.tag.incmwfact(0.1) end),
    awful.key({ modkey, }, "Left", function() awful.tag.incmwfact(-0.1) end),
    awful.key({ modkey, }, "Up", function() awful.client.incwfact(0.1) end),
    awful.key({ modkey, }, "Down", function() awful.client.incwfact(-0.1) end),
    awful.key({ modkey, }, ",", function() awful.tag.incnmaster(1, nil, true) end),
    awful.key({ modkey, }, ".", function() awful.tag.incnmaster(-1, nil, true) end),
    awful.key({ modkey, "Control" }, ",", function() awful.tag.incncol(1, nil, true) end),
    awful.key({ modkey, "Control" }, ".", function() awful.tag.incncol(-1, nil, true) end),
    awful.key({ modkey, }, "d", function() awful.layout.inc(1) end),


    -- Volume keys
    -- awful.key({}, "XF86AudioRaiseVolume", function () awful.spawn.with_shell("pamixer -i 5 --unmute && volume.sh",    false) end),
    -- awful.key({}, "XF86AudioLowerVolume", function () awful.spawn.with_shell("pamixer -d 5 --unmute && volume.sh",    false) end),
    awful.key({}, "XF86AudioRaiseVolume", function() volume.update(2) end),
    awful.key({}, "XF86AudioLowerVolume", function() volume.update(-2) end),
    awful.key({}, "XF86AudioMute",        function() volume.toggle_mute() end),

    -- Media keys
    awful.key({}, "XF86AudioPlay", function() awful.util.spawn("playerctl -p spotify play-pause", false) end),
    awful.key({}, "XF86AudioRewind", function() awful.util.spawn("playerctl -p spotify previous", false) end),
    awful.key({}, "XF86AudioForward", function() awful.util.spawn("playerctl -p spotify next", false) end),

    -- Audio sink
    awful.key({}, "XF86Launch5", function() awful.util.spawn("pactl set-default-sink Headphones", false) end),
    awful.key({}, "XF86Tools", function() awful.util.spawn("pactl set-default-sink alsa_output.usb-Focusrite_Scarlett_18i20_USB-00.pro-output-0", false) end),

    -- Utils
    -- awful.key({ modkey, }, "space",
    --     function() awful.util.spawn("rofi -m -4 -combi-modi 'window,drun' -show combi -modi combi", false) end),
    awful.key({ modkey, }, "h",
        function() awful.util.spawn("onagre --scale 1.2", false) end),
    awful.key({ modkey, }, "s",
        function() awful.spawn.with_shell("scrot -s -f -b ~/scrot.png && xclip -selection clipboard -t image/png ~/scrot.png && rm ~/scrot.png"
                , false)
        end),
    awful.key({ modkey, }, "r", function() awful.spawn.with_shell("replay-sorcery save", false) end),
    awful.key({ modkey, "Shift" }, "semicolon", function() awful.spawn.with_shell("smile", false) end),
    -- awful.key({ modkey, "Control" }, "space",
    --     function() awful.spawn.with_shell("~/.config/eww/modules/menu/menu.sh", false) end),
-- awful.key({ modkey,  }, "r",     function () awful.spawn.with_shell("scrot -s -b ~/scrot.png && xclip -selection clipboard -t image/png ~/scrot.png && rm ~/scrot.png", false) end)

    -- G600 buttons {{{
    awful.key({modkey}, "F1",  function() end),
    awful.key({modkey}, "F2",  function() end),
    awful.key({modkey}, "F3",  function() end),
    awful.key({modkey}, "F4",  function() end),
    awful.key({modkey}, "F5",  function() end),
    -- awful.key({modkey}, "F6",  function() naughty.notify({title="hey"}) end),
    -- awful.key({modkey}, "F6", function(c) local cmenu = menu.menu(c) cmenu.visible = not cmenu.visible end),
    awful.key({modkey}, "F7",  function() end),
    awful.key({modkey}, "F8",  function() end),
    awful.key({modkey}, "F9",  function() end),
    awful.key({modkey}, "F10", function() end),
    awful.key({modkey}, "F11", function() end),
    awful.key({modkey}, "F12", function() end),
    awful.key({modkey}, "F13", function() end),
    awful.key({modkey}, "F14", function() end),
    awful.key({modkey}, "F15", function() end),
    awful.key({modkey}, "F16", function() end),
    awful.key({modkey}, "F17", function() end),
    awful.key({modkey}, "F18", function() end),
    awful.key({modkey}, "F19", function() end),
    awful.key({modkey}, "F20", function() end),
    awful.key({modkey}, "F21", function() end)

    -- END G600 buttons }}}

)

clientkeys = gears.table.join(
    awful.key({modkey}, "F6", function(c) local cmenu = menu.menu(c) cmenu.visible = not cmenu.visible end),
    -- awful.key({ modkey,           }, "h",
    --     function(c)
    --         local cmenu = menu.menu(c)
    --         cmenu.visible = not cmenu.visible
    --     end),

    awful.key({ modkey, }, "b",
        function(c)
            -- awful.titlebar.toggle(c)
            -- c:emit_signal("request::titlebars")
            titlebars.toggle(c)
            -- naughty.notify({title=c.name})
        end),
    awful.key({ modkey, }, "v",
        function(c)
            naughty.notify({title=c.name})
            -- awful.titlebar.hide(c, "left")
            -- awful.titlebar.hide(c, "top")
            titlebars.hide(c)
        end),
    awful.key({ modkey, }, "c", function(c) c:kill() end),
    awful.key({ modkey, }, "f",
        function(c)
            if c.floating then
                c.floating = false
                titlebars.hide(c)
            else
                c.floating = true
                titlebars.show(c)
                c:geometry({ width = dpi(1200), height = dpi(700) })
                awful.placement.centered(c)
            end
        end),
    awful.key({ modkey, }, "u", function(c) c.ontop = not c.ontop end),
    awful.key({ modkey, }, "y", function(c) c.sticky = not c.sticky end),
    awful.key({ modkey, "Control" }, "l", function(c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, "Control" }, "o", function(c) c:move_to_screen() end),
    awful.key({ modkey, }, "x", function(c) c.maximized = not c.maximized c:raise() end),
    awful.key({ modkey, "Shift"}, "x", function(c) c.fullscreen = not c.fullscreen c:raise() end)
)


firefox_keys = gears.table.join(
    awful.key(meh, "n", function(c) awful.util.spawn("xdotool key --clearmodifiers Control+Tab") end),
    awful.key(meh, "e", function(c) awful.util.spawn("xdotool key --clearmodifiers Control+Shift+Tab") end)

--[[
       [ --Not possible right now because meh+ctrl isn't a thing. Make meh right side mods to have multiple ctrl?
       [ awful.key(meh, "Control", "e", function (c) awful.util.spawn("xdotool key --clearmodifiers Control+Shift+Prior") end),
       [ awful.key(meh, "Control", "n", function (c) awful.util.spawn("xdotool key --clearmodifiers Control+Shift+Next") end)
       ]]
)

discord_keys = gears.table.join(
    awful.key(meh, "n",    function(c) awful.util.spawn("xdotool key --clearmodifiers Alt+Down")         end),
    awful.key(meh, "e",    function(c) awful.util.spawn("xdotool key --clearmodifiers Alt+Up")           end),

    awful.key(meh, "Down", function(c) awful.util.spawn("xdotool key --clearmodifiers Alt+Shift+Down")   end),
    awful.key(meh, "Up",   function(c) awful.util.spawn("xdotool key --clearmodifiers Alt+Shift+Up")     end),

    awful.key(meh, "m",    function(c) awful.util.spawn("xdotool key --clearmodifiers Control+Alt+Down") end),
    awful.key(meh, "i",    function(c) awful.util.spawn("xdotool key --clearmodifiers Control+Alt+Up")   end)
)

-- Set keys
root.keys(globalkeys)
-- END Keybinds }}}

-- {{{ Mouse bindings

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),

    awful.button({}, 2, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),

    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),

    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

root.buttons(gears.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end),
    awful.button({}, 12, function() naughty.notify({title="CLICK"}) end),
    awful.button({}, 6, awful.tag.viewnext),
    awful.button({}, 7, awful.tag.viewprev)
))

firefox_buttons = gears.table.join(
    awful.button({}, 10, function() awful.util.spawn("xdotool key --clearmodifiers Ctrl+Tab") end),
    awful.button({}, 11, function() awful.util.spawn("xdotool key --clearmodifiers Ctrl+Shift+Tab") end),
    awful.button({}, 13, function() awful.util.spawn("xdotool key --clearmodifiers Ctrl+w") end),
    awful.button({}, 12, function() awful.util.spawn("xdotool key --clearmodifiers Ctrl+Shift+t") end)
)

-- }}}

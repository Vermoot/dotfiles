local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local gears     = require("gears")
local dpi       = require("beautiful.xresources").apply_dpi
local naughty   = require("naughty")

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
      titlebars_enabled = false,
    },
  },

  { rule = { name = "Fusion360", type = "dialog" },
    properties = {
      border_width = 0,
      titlebars_enabled = false,
    },
  },

  { rule = { class = "fusion360.exe" },
    except = { transient_for = nil },
    properties = {
      sticky = false
    },
  },

  { rule = { name = "Fusion360" },
    except = { transient_for = nil },
    properties = {
      sticky = false
    },
  },

  { rule = { class = "kando" },
    properties = {
      border_width = 0
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

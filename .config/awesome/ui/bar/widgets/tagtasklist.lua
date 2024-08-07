local awful   = require("awful")
local wibox   = require("wibox")
local gears   = require("gears")
local dpi     = require("beautiful.xresources").apply_dpi
local helpers = require("ui.helpers")
local naughty = require("naughty")
local dragndropper = require("ui.dragndropper")

local M = {}

local function reset_hover(w)
  if w.before then
    for property, _ in pairs(w.before) do
      if property == "cursor" and w.before.cursor then
        w.mw = mouse.current_wibox
        if w.mw then
          w.mw.cursor = w.before.cursor
          w.before.cursor = nil
        end
      else
        w[property] = w.before[property]
        w.before[property] = nil
      end
    end
  end
end

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
                                          end)
)

local function tasklist (s, tag)
  local function only_this_tag(c, _)
    if c.type == "utility" or c.class == "plasmashell" then return false end
    for _, t in ipairs(c:tags()) do return t == tag end
    return false
  end
  return awful.widget.tasklist {
    buttons = tasklist_buttons,
    filter          = only_this_tag,
    screen = s,
    -- buttons         = tasklist_buttons,
    layout          = { layout = wibox.layout.flex.vertical, spacing = dpi(8) },
    -- layout = wibox.layout.fixed.vertical,
    widget_template = {
      widget = wibox.container.background,
      shape = helpers.rounded(4),
      {
        widget = awful.widget.clienticon,
        id = "clienticon",
      },
      update_callback = function(self, c, _, _)
        -- Do something to differentiate between active and inactive
        if c.active then
          -- self.bg = "#ebdbb233"
        else
          -- self.bg = "#ebdbb200"
        end
      end,
      create_callback = function(self, c, _, _)
        self:get_children_by_id("clienticon")[1].client = c
      end,
    },
  }
end

local update_callback = function(self, tag, _, _)
  local tagbox = self:get_children_by_id("tagbox")[1]
  if tag.selected then
    reset_hover(tagbox)
    tagbox.shape_border_color = "#7c6f64"
    tagbox.bg = "#665c54"
  else
    tagbox.shape_border_color = "#423e3c"
    tagbox.bg = "#3c3836"
  end
  if #tag:clients() <= 1 then
    self.forced_height = dpi(32)
  else
    self.forced_height = nil
  end
end

local create_callback = function(self, tag, _, _)
  local tagbox = self:get_children_by_id("tagbox")[1]
  tagbox.shape_border_width = 1
  self:get_children_by_id("placeholder")[1]:add(tasklist(tag.screen, tag))
  update_callback(self, tag, _, _)
  helpers.hover(tagbox,
    {
      inhibitor = function() return tag.selected end,
      shape_border_color = "#524f4d",
      bg = "#504945",
      cursor = "hand1",
    }
  )
  -- dragndropper.test(tagbox)
end

local tag_template = {
  {
    {
      {
        id = "placeholder",
        layout = wibox.layout.flex.vertical,
      },
      widget = wibox.container.margin,
      margins = dpi(6),
    },
    widget = wibox.container.background,
    id = "tagbox",
    shape = helpers.rounded(3),
    -- hover_shape_border_color = "#524f4d",
    -- hover_bg = "#504945",
    -- hover_cursor = "hand1",
  },
  left  = 2,
  right = 2,
  widget = wibox.container.margin,
  layout = wibox.layout.flex.vertical,
  create_callback = create_callback,
  update_callback = update_callback,
}

local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
    t:view_only()
  end),
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

M.widget = function (s)
  return awful.widget.taglist {
    screen  = s,
    buttons = taglist_buttons,
    filter  = awful.widget.taglist.filter.all,
    widget_template = tag_template,
    layout = {
      layout = wibox.layout.fixed.vertical,
      spacing = dpi(4)
    },
  }
end

return M

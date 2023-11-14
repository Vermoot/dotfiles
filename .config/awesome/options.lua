local awful = require("awful")
local beautiful = require("beautiful")

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
awful.mouse.snap.client_enabled = true
awful.mouse.snap.default_distance = 30
-- }}}

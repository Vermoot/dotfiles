local wezterm = require 'wezterm';

return {

-- Globals {{{
  skip_close_confirmation_for_processes_named = {
      "bash", "sh", "zsh", "fish", "tmux"
  },
-- }}}

-- Appearance {{{
  enable_tab_bar = false,
  window_padding = {
    left = 30,
    right = 30,
    top = 30,
    bottom = 30,
  },
  -- window_background_opacity=1.0,
--}}}

-- Font {{{
  font = wezterm.font_with_fallback({
      "Terminus (TTF)",
      "JetBrainsMono Nerd Font"
    }),
  font_size = 12,
-- }}}

-- Colors {{{
  colors = {
      -- The default text color
      foreground = "#ebdbb2",
      -- The default background color
      background = "#282828",

      -- Overrides the cell background color when the current cell is occupied by the
      -- cursor and the cursor style is set to Block
      cursor_bg = "#ebdbb2",
      -- Overrides the text color when the current cell is occupied by the cursor
      cursor_fg = "#282828",

      -- the foreground color of selected text
      selection_fg = "black",
      -- the background color of selected text
      selection_bg = "#fffacd",

      -- The color of the scrollbar "thumb"; the portion that represents the current viewport
      scrollbar_thumb = "#222222",

      -- The color of the split lines between panes
      split = "#444444",

      ansi = {"#282828", "#cc241d", "#98971a", "#d79921", "#458588", "#b16286", "#689d6a", "#a89984"},
      brights = {"#928374", "#fb4934", "#b8bb26", "#fabd2f", "#83a598", "#d3869b", "#8ec07c", "#ebdbb2"},

      -- Arbitrary colors of the palette in the range from 16 to 255
      indexed = {[136] = "#af8700"},
  },
-- }}}

-- Key binds {{{
  keys = {
      {key="n", mods="CTRL", action="SpawnWindow"},
      {key="w", mods="CTRL", action=wezterm.action{CloseCurrentTab={ confirm=true } } },
    }
--}}}

}
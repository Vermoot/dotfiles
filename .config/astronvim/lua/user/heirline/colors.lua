-- Customize colors for each element each element has a `_fg` and a `_bg`
return function(colors)
  local get_hlgroup = require("astronvim.utils").get_hlgroup
  colors.git_branch_fg = get_hlgroup("Conditional").fg
  colors.normal = "#8ec07c"
  colors.insert = "#458588"
  colors.insert_fg = "#ebdbb2"
  return colors
end

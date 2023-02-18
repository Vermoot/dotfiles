local highlights = require("neo-tree.ui.highlights")
return {
  close_if_last_window = true,
  window = {
    width = 30,
    mappings = {
      ["<C-M-S-m>"]  = "prev_source",
      ["<C-M-S-i>"] = "next_source",
      ["<Right>"] = "open",
      ["<Left>"]  = "close_node",
    }
  },
  filesystem = {
    filtered_items = {
      hide_gitignored = false,
    },
    components = {
      icon = function(config, node, state)
        local icon = config.default or " "
        local padding = config.padding or "  "
        local highlight = config.highlight or highlights.FILE_ICON

              if node.type == "directory" then
                highlight = highlights.DIRECTORY_ICON
                if node:is_expanded() then
                  icon = config.folder_open or "-"
                else
                  icon = config.folder_closed or "+"
                end
              elseif node.type == "file" then
                local success, web_devicons = pcall(require, "nvim-web-devicons")
                if success then
                  local devicon, hl = web_devicons.get_icon(node.name, node.ext)
                  icon = devicon or icon
                  highlight = hl or highlight
                end
              end

              return {
                text = icon .. padding,
                highlight = highlight,
              }
            end,
  }
  }
}

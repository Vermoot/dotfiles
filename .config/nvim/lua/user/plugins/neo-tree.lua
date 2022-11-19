return {
  close_if_last_window = true,
  window = {
    width = 30,
    mappings = {
      ["<M-CR>"]  = "prev_source",
      ["<M-Tab>"] = "next_source",
      ["<Right>"] = "open",
      ["<Left>"]  = "close_node",
    }
  },
  filesystem = {
    filtered_items = {
      hide_gitignored = true,
    }
  }
}

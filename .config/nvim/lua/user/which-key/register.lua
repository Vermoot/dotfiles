return {
  -- Add bindings which show up as group name
  -- first key is the mode, n == normal mode
  n = {
    -- second key is the prefix, <leader> prefixes
    ["<leader>"] = {
      -- third key is the key to bring up next level and its displayed
      -- group name in which-key top level menu
      ["b"] = { name = "Buffer" },
      ["<leader>"] = {name = "MORE!"},
      ["<leader>c"] = {name = "ChatGPT"},
    },
  },
}

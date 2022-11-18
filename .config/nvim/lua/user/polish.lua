return function()

  -- Highlight on yank
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank { timeout = 800 }
    end,
    desc = "Provide a visual feedback on copying.",
  })

end

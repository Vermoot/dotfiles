-- Options
local options = {
  number = true,
  fileencoding = "utf-8",
  hlsearch = true,
  ignorecase = true,
  smartcase = true,
  smartindent = true,
  splitbelow = true,
  splitright = true,
  timeoutlen = 1000,
  undofile = true,
  foldmethod = "marker",
  clipboard = "unnamedplus",
  expandtab = true,
  scrolloff = 4,
  signcolumn = "yes",
  sidescrolloff = 8,
  wildmode = {'list', 'longest'},
  wrap = true,
  linebreak = true,
  list = false, -- Don't wrap in the middle of a word
  mouse = "a",

  -- Colors
  termguicolors = true,
  background = "dark",
}

-- vim.opt.whichwrap:append('<>hl')

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd "colorscheme gruvbox"

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank { timeout = 800 }
  end,
  desc = "Provide a visual feedback on copying.",
})

return {
  opt = {
    -- set to true or false etc.
    spell          = false, -- sets vim.opt.spell

    number         = true,
    relativenumber = true,
    fileencoding   = "utf-8",
    hlsearch       = true,
    ignorecase     = true,
    smartcase      = true,
    smartindent    = true,
    splitbelow     = true,
    splitright     = true,
    timeoutlen     = 300,
    undofile       = true,
    foldmethod     = "marker",
    clipboard      = "unnamedplus",
    expandtab      = true,
    scrolloff      = 4,
    signcolumn     = "yes",
    sidescrolloff  = 8,
    wildmode       = { 'list', 'longest' },
    virtualedit    = "all",

    wrap           = true,
    linebreak      = true,
    list           = false, -- Don't wrap in the middle of a word

    mouse          = "a",

    -- Colors
    termguicolors  = true,
    background     = "dark",
  },
  g = {
    mapleader = " ", -- sets vim.g.mapleader
    autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    cmp_enabled = true, -- enable completion at start
    autopairs_enabled = true, -- enable autopairs at start
    diagnostics_enabled = true, -- enable diagnostics at start
    status_diagnostics_enabled = true, -- enable diagnostics in statusline
    icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
  },
}

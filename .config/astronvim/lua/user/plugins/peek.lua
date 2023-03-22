return { 'toppair/peek.nvim',
  ft = "markdown",
  build = 'deno task --quiet build:fast',
  cmd = {
    "PeekOpen",
    "PeekClose",
  },
  opts = {
    app = 'firefox',
  },
}

vim.pack.add({
  'https://github.com/saghen/blink.lib',
  'https://github.com/saghen/blink.cmp',
  "https://github.com/rafamadriz/friendly-snippets" 
})

local cmp = require('blink.cmp')

cmp.build():pwait()
cmp.setup({

  keymap = { preset = "super-tab" },

  completion = {
    documentation = { auto_show = true },
    menu = { border = "rounded" },
  },

  signature = { window = { border = "rounded" } },

  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
})

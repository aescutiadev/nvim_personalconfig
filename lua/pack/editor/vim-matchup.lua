vim.pack.add({ "https://github.com/andymass/vim-matchup" })

vim.g.matchup_treesitter_stopline = 500

-- or call the setup function provided as a helper. It defines the
-- configuration vars for you
require('match-up').setup({
  treesitter = {
    enabled = true,
    stopline = 500
  }
})

vim.pack.add({ "https://github.com/andymass/vim-matchup" })

vim.g.matchup_treesitter_stopline = 500

-- matchup registra sus propios autocmds en setup(); se difiere al primer idle
-- para no pagar el costo en el arranque. El setup no depende del filetype.
require("config.defer").run("matchup", function()
  require('match-up').setup({
    treesitter = {
      enabled = true,
      stopline = 500
    }
  })
end)

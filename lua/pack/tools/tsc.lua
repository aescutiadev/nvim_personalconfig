vim.pack.add({ "https://github.com/dmmulroy/tsc.nvim" })

-- Sólo registra el comando :TSC y sus autocmds; no hace falta al arrancar.
require("config.defer").run("tsc", function()
  require('tsc').setup()
end)

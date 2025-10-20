require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

-- Load Snacks types for better LSP support (after plugins)
vim.schedule(function()
  pcall(require, "config.snacks-types")
end)

-- Completado nativo de Neovim 0.12
local M = {}

function M.setup()
  vim.o.autocomplete = true
  vim.o.pumborder = "rounded"
  vim.opt.completeopt = { "menu", "menuone", "noselect", "nearest" }
  vim.opt.pumheight = 15
end

return M

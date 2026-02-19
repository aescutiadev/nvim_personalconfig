-- Folding configurado en core/options.lua con treesitter
-- Este módulo contiene mejoras de folding
local M = {}

function M.setup()
  -- Texto de fold vacío para usar highlight nativo de treesitter (Neovim 0.10+)
  vim.opt.foldtext = ""
end

return M

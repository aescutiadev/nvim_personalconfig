-- Configuración de completado manejada por blink.cmp (lua/plugins/editor.lua)
-- Este módulo contiene ajustes complementarios de completado
local M = {}

function M.setup()
  vim.opt.completeopt = { "menu", "menuone", "noselect" }
  vim.opt.pumheight = 15
end

return M

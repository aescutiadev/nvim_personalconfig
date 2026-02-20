-- Formateo con LSP
local M = {}

function M.setup()
  vim.keymap.set({ "n", "v" }, "<leader>cf", function()
    vim.lsp.buf.format({ async = true })
  end, { desc = "Formatear con LSP" })
end

return M

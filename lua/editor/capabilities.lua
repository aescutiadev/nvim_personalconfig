local M = {}

function M.setup()
  -- Capabilities mejoradas con blink.cmp para todos los servidores LSP
  local ok, blink = pcall(require, "blink.cmp")
  if ok then
    vim.lsp.config("*", {
      capabilities = blink.get_lsp_capabilities(),
    })
  end
end

return M

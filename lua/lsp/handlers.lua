local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspHandlers", { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if not client then return end

      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end

      -- Navegación (complementa los defaults de Neovim 0.11: K, grn, gra, grr, gri)
      map("gd", vim.lsp.buf.definition, "Ir a definición")
      map("gD", vim.lsp.buf.declaration, "Ir a declaración")
      map("gK", vim.lsp.buf.signature_help, "Signature help")
      map("<leader>D", vim.lsp.buf.type_definition, "Type definition")

      -- Resaltar referencias bajo el cursor
      if client:supports_method("textDocument/documentHighlight") then
        local hl_group = vim.api.nvim_create_augroup("LspHighlight_" .. event.buf, { clear = true })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          group = hl_group,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          group = hl_group,
          callback = vim.lsp.buf.clear_references,
        })
      end

      -- Inlay hints toggle
      if client:supports_method("textDocument/inlayHint") then
        map("<leader>uH", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
        end, "Toggle inlay hints")
      end
    end,
  })
end

return M

local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspHandlers", { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if not client then return end

      local map = function(keys, func, desc, modes)
        vim.keymap.set(modes or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end

      -- Navegación (complementa los defaults de Neovim 0.11: K, grn, gra, grr, gri)
      -- map("gd", vim.lsp.buf.definition, "Ir a definición")
      -- map("gD", vim.lsp.buf.declaration, "Ir a declaración")
      map("gK", vim.lsp.buf.signature_help, "Signature help")
      -- map("<leader>lT", vim.lsp.buf.type_definition, "Type definition")

      -- 🔧 Grupo <leader>l — Acciones LSP centralizadas
      -- Navegación
      map("<leader>ld", function() Snacks.picker.lsp_definitions() end, "Ir a definición")
      map("<leader>lD", function() Snacks.picker.lsp_declarations() end, "Ir a declaración")
      map("<leader>lr", function() Snacks.picker.lsp_references() end, "Referencias")
      map("<leader>li", function() Snacks.picker.lsp_implementations() end, "Implementaciones")
      map("<leader>lt", function() Snacks.picker.lsp_type_definitions() end, "Type definition")
      map("<leader>lI", function() Snacks.picker.lsp_incoming_calls() end, "Llamadas entrantes")
      map("<leader>lO", function() Snacks.picker.lsp_outgoing_calls() end, "Llamadas salientes")

      -- Acciones
      map("<leader>la", vim.lsp.buf.code_action, "Code action", { "n", "v" })
      map("<leader>ln", vim.lsp.buf.rename, "Renombrar símbolo")
      map("<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Formatear", { "n", "v" })
      map("<leader>lk", vim.lsp.buf.hover, "Hover documentación")
      map("<leader>ls", vim.lsp.buf.signature_help, "Signature help")

      -- Símbolos
      map("<leader>lS", function() Snacks.picker.lsp_symbols() end, "Símbolos del documento")
      map("<leader>lW", function() Snacks.picker.lsp_workspace_symbols() end, "Símbolos del workspace")

      -- Diagnósticos
      map("<leader>ll", vim.diagnostic.open_float, "Diagnóstico en línea")
      map("<leader>lq", vim.diagnostic.setloclist, "Diagnósticos a loclist")

      -- Toggle / Config
      map("<leader>lR", function()
        local clients = vim.lsp.get_clients({ bufnr = event.buf })
        for _, c in ipairs(clients) do
          vim.lsp.stop_client(c.id)
        end
        vim.defer_fn(function() vim.cmd("edit") end, 500)
        vim.notify("LSP reiniciado", vim.log.levels.INFO)
      end, "Reiniciar LSP")

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

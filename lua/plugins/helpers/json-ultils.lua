local schemastore = {
  "b0o/schemastore.nvim",
  lazy = true,
  config = function()
    local schemastore = require("schemastore")

    vim.lsp.config("jsonls", {
      settings = {
        json = {
          schemas = schemastore.json.schemas(),
          validate = { enable = true },
        },
      },
    })

    -- Mapeos de teclas LSP (igual que Lua)
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("JsonLspKeymaps", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("<leader>lr", vim.lsp.buf.rename, "LSP Rename")
        map("<leader>la", vim.lsp.buf.code_action, "LSP Code Action")
        map("<leader>lf", vim.lsp.buf.format, "LSP Format")
        map("<leader>lt", vim.lsp.buf.type_definition, "LSP Type Definition")
        map("<leader>li", vim.lsp.buf.implementation, "LSP Implementation")
        map("gO", vim.lsp.buf.document_symbol, "LSP Document Symbols")
      end,
    })
  end,
}

return { schemastore }

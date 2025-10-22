-- lua/plugins/lspkind.lua
return {
  "onsails/lspkind.nvim",
  lazy = true, -- Carga bajo demanda
  config = function()
    local lspkind = require("lspkind")

    -- Inicializar lspkind con tu mapa de íconos
    lspkind.init({
      mode = 'symbol_text', -- Mostrar ícono + texto
      preset = 'codicons',  -- Íconos estilo VSCode
      symbol_map = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
      },
    })

    -- Interceptar completado de LSP nativo y agregar íconos
    vim.lsp.handlers["textDocument/completion"] = function(err, result)
      if err or not result or vim.tbl_isempty(result.items) then
        return
      end

      local items = result.items

      for _, item in ipairs(items) do
        local kind_name = vim.lsp.protocol.CompletionItemKind[item.kind] or "Text"
        item.kind = require("lspkind").symbol_map[kind_name] or kind_name
      end

      vim.lsp.util.complete_items(items)
    end
  end,
}

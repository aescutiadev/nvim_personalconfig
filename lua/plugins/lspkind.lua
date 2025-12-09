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
        Copilot = "",
      },
    })

    -- Note: Completion icons are now handled by blink.cmp
  end,
}

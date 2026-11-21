vim.pack.add({
  'https://github.com/saghen/blink.lib',
  'https://github.com/saghen/blink.cmp',
  "https://github.com/rafamadriz/friendly-snippets"
})

local cmp = require('blink.cmp')

-- El build de la lib nativa NO va en el arranque: `pwait()` bloquea, y cuando
-- el plugin cambia de versión son ~30 s de Neovim congelado sin explicación.
-- Mismo patrón que el hook de tiktoken en pack/ia/copilot.lua.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local spec = ev.data.spec
    if spec and spec.name == "blink.cmp" and (ev.data.kind == "install" or ev.data.kind == "update") then
      vim.schedule(function()
        cmp.build():pwait(120000)
        vim.notify("blink.cmp: lib nativa reconstruida", vim.log.levels.INFO)
      end)
    end
  end,
})

-- Si la lib no está, blink ya avisa y cae al matcher en Lua; esto sólo evita
-- que el usuario se pregunte por qué el fuzzy se siente distinto.
if not cmp.library_available() then
  vim.notify(
    "blink.cmp: lib nativa ausente. Corré `:lua require('blink.cmp').build():pwait()` una vez.",
    vim.log.levels.WARN
  )
end

cmp.setup({
  keymap = { preset = "super-tab", ["<C-y>"] = { "select_and_accept" } },

  completion = {
    documentation = { auto_show = true },
    menu = { border = "rounded" },
  },

  signature = { window = { border = "rounded" } },

  sources = {
    default = { "lsp", "path", "snippets", "buffer", "ai" },
    providers = {
      ai = {
        name = "AI Custom",
        module = "pack.editor.ai_source",
        async = true,
      },
    },
  },
})

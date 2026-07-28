require("editor.capabilities").setup()
require("editor.handlers").setup()

-- 🩺 Diagnósticos
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = 'if_many',
    prefix = '●',
  },
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN]  = ' ',
      [vim.diagnostic.severity.INFO]  = ' ',
      [vim.diagnostic.severity.HINT]  = '󰌵 ',
    },
  },
})

-- 🧩 Capabilities de blink para TODOS los servidores
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- 🚀 Servidores a activar
vim.lsp.enable({
  "html",
  "cssls",
  "astro",
  -- "vtsls",
  "gopls",
  "taplo",
  "biome",
  "lua_ls",
  "yamlls",
  "bashls",
  "jsonls",
  "bashls",
  "marksman",
  "dockerls",
  "tailwindcss",
  "mdx_analizer",
  "basedpyright",
  "intelephense",
  "css_variables",
  "docker_language_server",
  "docker_compose_language_service",
})

-- 💡 Inlay hints
vim.g.inlay_hints_enabled = false

vim.keymap.set("n", "<leader>uh", function()
  vim.g.inlay_hints_enabled = not vim.g.inlay_hints_enabled
  for _, client in ipairs(vim.lsp.get_clients()) do
    for bufnr in pairs(client.attached_buffers or {}) do
      vim.lsp.inlay_hint.enable(vim.g.inlay_hints_enabled, { bufnr = bufnr })
    end
  end
  vim.notify("Inlay hints: " .. (vim.g.inlay_hints_enabled and "activados" or "desactivados"))
end, { desc = "Toggle inlay hints" })

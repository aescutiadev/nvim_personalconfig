local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("blink.cmp").get_lsp_capabilities()
)

local lsp_name = "taplo"

vim.lsp.config(lsp_name, {
  cmd = { 'taplo', 'lsp', 'stdio' },

  capabilities = capabilities,

  -- filetypes copied and adjusted from tailwindcss-intellisense
  filetypes = { 'toml' },
  root_markers = { '.taplo.toml', 'taplo.toml', '.git' },
})

vim.lsp.enable(lsp_name)

return {}

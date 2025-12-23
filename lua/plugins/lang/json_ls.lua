local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("blink.cmp").get_lsp_capabilities()
)

vim.lsp.config("jsonls", {
  cmd = { 'vscode-json-language-server', '--stdio' },

  capabilities = capabilities,

  filetypes = { 'json', 'jsonc' },
  init_options = {
    provideFormatter = true,
  },
  root_markers = { '.git' },
})

vim.lsp.enable("jsonls")

return {}

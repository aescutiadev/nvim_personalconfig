---@brief
--- https://github.com/mdx-js/mdx-analyzer
---
--- `mdx-analyzer`, a language server for MDX

local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("blink.cmp").get_lsp_capabilities()
)

vim.lsp.config("mdx_analyzer", {
  cmd = { 'mdx-language-server', '--stdio' },

  capabilities = capabilities,

  filetypes = { 'mdx' },
  root_markers = { 'package.json' },
  settings = {},
  init_options = {
    typescript = {},
  },
})

vim.lsp.enable("mdx_analyzer")

return {}

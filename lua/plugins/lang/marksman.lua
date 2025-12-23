---@brief
---
--- https://github.com/artempyanykh/marksman
---
--- Marksman is a Markdown LSP server providing completion, cross-references, diagnostics, and more.
---
--- Marksman works on MacOS, Linux, and Windows and is distributed as a self-contained binary for each OS.
---
--- Pre-built binaries can be downloaded from https://github.com/artempyanykh/marksman/releases

local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("blink.cmp").get_lsp_capabilities()
)

vim.lsp.config("marksman", {
  cmd = { 'marksman', 'server' },

  capabilities = capabilities,

  filetypes = { 'markdown', 'markdown.mdx' },
  root_markers = { '.marksman.toml', '.git' },
})

vim.lsp.enable("marksman")

return {}

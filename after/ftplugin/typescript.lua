if vim.fn.executable("tsgo") == 1 then
  vim.lsp.enable("tsgo")
else
  vim.lsp.enable("vtsls")
end

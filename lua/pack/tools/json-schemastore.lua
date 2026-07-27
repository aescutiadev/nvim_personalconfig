vim.pack.add({
  {
    src = "https://github.com/b0o/schemastore.nvim",
  },
})

local schemastore = require("schemastore")

vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = schemastore.json.schemas(),
      validate = { enable = true },
    },
  },
})

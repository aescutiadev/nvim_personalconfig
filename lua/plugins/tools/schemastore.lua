return {
  "b0o/schemastore.nvim",
  lazy = true,
  config = function()
    local schemastore = require("schemastore")

    vim.lsp.config("jsonls", {
      settings = {
        json = {
          schemas = schemastore.json.schemas(),
          validate = { enable = true },
        },
      },
    })
  end,
}

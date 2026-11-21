vim.pack.add({
  {
    src = "https://github.com/b0o/schemastore.nvim",
  },
})

-- El catálogo de schemas son ~7 ms de parseo que sólo sirven para JSON/YAML.
-- Se carga la primera vez que se abre uno de esos buffers.
require("config.defer").on_filetype({ "json", "jsonc", "json5", "yaml", "yml" }, "schemastore", function()
  local schemastore = require("schemastore")

  vim.lsp.config("jsonls", {
    settings = {
      json = {
        schemas = schemastore.json.schemas(),
        validate = { enable = true },
      },
    },
  })
end)

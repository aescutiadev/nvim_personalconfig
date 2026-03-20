---@type vim.lsp.Config
return {
  cmd = { "intelephense", "--stdio" },
  filetypes = { "php" },
  root_markers = { "composer.json", "composer.lock", ".git" },
  settings = {
    intelephense = {
      files = {
        maxSize = 5000000,
      },
      environment = {
        phpVersion = "8.5",
      },
      completion = {
        fullyQualifyGlobalConstantsAndFunctions = false,
        triggerParameterHints = true,
        insertUseDeclaration = true,
      },
      phpdoc = {
        returnVoid = false,
      },
      telemetry = {
        enabled = false,
      },
    },
  },
}

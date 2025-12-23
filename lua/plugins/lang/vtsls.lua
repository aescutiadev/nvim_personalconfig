local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("blink.cmp").get_lsp_capabilities()
)

vim.lsp.config("vtsls", {
  cmd = { "vtsls", "--stdio" },

  capabilities = capabilities,

  init_options = {
    hostInfo = "neovim",

    -- TS / JS language preferences
    typescript = {
      preferences = {
        importModuleSpecifierPreference = "shortest",
        quotePreference = "auto",
      },
    },

    -- tsserver FILE preferences
    tsserver_file_preferences = {
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,

      includeCompletionsForModuleExports = true,
      includeCompletionsForImportStatements = true,

      quotePreference = "auto",
    },

    -- tsserver FORMAT options
    tsserver_format_options = {
      allowIncompleteCompletions = false,
      allowRenameOfImportPath = true,
      semicolons = "insert",
      indentSize = 2,
      tabSize = 2,
      convertTabsToSpaces = true,
      insertSpaceAfterCommaDelimiter = true,
      insertSpaceAfterConstructor = false,
    },
  },

  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },

  root_dir = function(bufnr, on_dir)
    local root_markers = {
      "package-lock.json",
      "yarn.lock",
      "pnpm-lock.yaml",
      "bun.lockb",
      "bun.lock",
    }

    -- exclude deno
    if vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" }) then
      return
    end

    local project_root =
        vim.fs.root(bufnr, { root_markers, { ".git" } })
        or vim.fn.getcwd()

    on_dir(project_root)
  end,
})

vim.lsp.enable("vtsls")

return {}

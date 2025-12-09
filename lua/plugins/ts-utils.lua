return {
  {
    "pmizio/typescript-tools.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      require("typescript-tools").setup({
        capabilities = capabilities,

        settings = {
          -- Recomendada: usa TS del proyecto (node_modules)
          typescript = {
            tsdk = "node_modules/typescript/lib",
          },

          separate_diagnostic_server = true,
          publish_diagnostic_on = "insert_leave",

          expose_as_code_action = {},
          tsserver_path = nil,
          tsserver_plugins = {},

          tsserver_max_memory = "auto",

          tsserver_format_options = {
            allowIncompleteCompletions = false,
            allowRenameOfImportPath = false,
          },

          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeCompletionsForModuleExports = true,
            quotePreference = "auto",
          },

          tsserver_locale = "en",

          complete_function_calls = false,
          include_completions_with_insert_text = true,

          code_lens = "off",
          disable_member_code_lens = true,
          disable_code_lens = true,

          jsx_close_tag = {
            enable = false,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        },
      })
    end,
  },
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = "BufRead package.json",
    opts = {},
  },
  {
    "dmmulroy/tsc.nvim",
    cmd = "TSC",
    opts = {},
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
      per_filetype = {
        html = { enable_close = true },
        javascript = { enable_close = true },
        typescript = { enable_close = true },
        javascriptreact = { enable_close = true },
        typescriptreact = { enable_close = true },
        astro = { enable_close = true },
      },
    },
  },
  -- TwoSlash queries - Anotaciones TypeScript inline
  {
    "marilari88/twoslash-queries.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {
      multi_line = true,     -- Mostrar anotaciones multi-línea
      is_enabled = true,     -- Habilitado por defecto
      highlight = "Comment", -- Resaltado como comentario
    },
    keys = {
      {
        "<leader>lt",
        "<cmd>TwoslashQueriesInspect<cr>",
        desc = "Toggle TwoSlash Queries",
        ft = { "typescript", "typescriptreact" },
      },
    },
  },
  {
    "axelvc/template-string.nvim",
    event = "InsertEnter",
    ft = { 'html', 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue', 'svelte', 'python', 'cs' },
    config = true, -- run require("template-string").setup()
  },
}

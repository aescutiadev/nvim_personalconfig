return {
  -- Mason - Package manager for LSP servers, DAP servers, linters & formatters
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Mason LSP Config - Bridges mason.nvim with lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "b0o/schemastore.nvim", -- JSON schemas
    },
    opts = {
      -- Lista de LSP servers que quieres instalar automáticamente
      ensure_installed = {
        "lua_ls", -- Lua Language Server
        "vtsls", -- TypeScript/JavaScript (más moderno que tsserver)
        "eslint", -- ESLint para linting JS/TS
        "html", -- HTML
        "cssls", -- CSS
        "jsonls", -- JSON
        "emmet_ls", -- Emmet para HTML/CSS
        "astro", -- Astro Language Server
        "tailwindcss", -- tailwindcss-language-server
      },
      -- Instalación automática de LSP servers cuando abras archivos
      automatic_installation = true,
      -- Add handlers configuration here instead of using setup_handlers
      handlers = {
        -- Handler por defecto para todos los servers
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = require("blink.cmp").get_lsp_capabilities(),
          })
        end,

        -- Configuración específica para Lua Language Server
        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup({
            capabilities = require("blink.cmp").get_lsp_capabilities(),
            settings = {
              Lua = {
                runtime = {
                  version = "LuaJIT",
                  path = vim.split(package.path, ";"),
                },
                diagnostics = {
                  globals = {
                    "vim",
                    "describe",
                    "it",
                    "before_each",
                    "after_each",
                    "pending",
                    "hs",
                    "spoon",
                    "utf8",
                  },
                  disable = { "missing-fields" },
                },
                workspace = {
                  library = {
                    vim.env.VIMRUNTIME,
                    "${3rd}/luv/library",
                    "${3rd}/busted/library",
                  },
                  checkThirdParty = false,
                  maxPreload = 100000,
                  preloadFileSize = 10000,
                },
                telemetry = { enable = false },
                completion = { callSnippet = "Replace" },
                format = {
                  enable = false, -- Usar stylua en su lugar
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          })
        end,

        -- Configuración específica para vtsls (TypeScript/JavaScript)
        ["vtsls"] = function()
          require("lspconfig").vtsls.setup({
            capabilities = require("blink.cmp").get_lsp_capabilities(),
            settings = {
              complete_function_calls = true,
              vtsls = {
                enableMoveToFileCodeAction = true,
                autoUseWorkspaceTsdk = true,
                experimental = {
                  completion = {
                    enableServerSideFuzzyMatch = true,
                  },
                },
              },
              typescript = {
                updateImportsOnFileMove = { enabled = "always" },
                suggest = {
                  completeFunctionCalls = true,
                },
                inlayHints = {
                  enumMemberValues = { enabled = true },
                  functionLikeReturnTypes = { enabled = true },
                  parameterNames = { enabled = "literals" },
                  parameterTypes = { enabled = true },
                  propertyDeclarationTypes = { enabled = true },
                  variableTypes = { enabled = false },
                },
                preferences = {
                  includePackageJsonAutoImports = "auto",
                },
              },
              javascript = {
                updateImportsOnFileMove = { enabled = "always" },
                suggest = {
                  completeFunctionCalls = true,
                },
                inlayHints = {
                  enumMemberValues = { enabled = true },
                  functionLikeReturnTypes = { enabled = true },
                  parameterNames = { enabled = "literals" },
                  parameterTypes = { enabled = true },
                  propertyDeclarationTypes = { enabled = true },
                  variableTypes = { enabled = false },
                },
                preferences = {
                  includePackageJsonAutoImports = "auto",
                },
              },
            },
          })
        end,

        -- Configuración para ESLint
        ["eslint"] = function()
          require("lspconfig").eslint.setup({
            capabilities = require("blink.cmp").get_lsp_capabilities(),
            settings = {
              codeAction = {
                disableRuleComment = {
                  enable = true,
                  location = "separateLine",
                },
                showDocumentation = {
                  enable = true,
                },
              },
              codeActionOnSave = {
                enable = false,
                mode = "all",
              },
              experimental = {
                useFlatConfig = false,
              },
              format = true,
              nodePath = "",
              onIgnoredFiles = "off",
              packageManager = "npm",
              problems = {
                shortenToSingleLine = false,
              },
              quiet = false,
              rulesCustomizations = {},
              run = "onType",
              useESLintClass = false,
              validate = "on",
              workingDirectory = {
                mode = "location",
              },
            },
          })
        end,

        -- Configuración para JSON
        ["jsonls"] = function()
          require("lspconfig").jsonls.setup({
            capabilities = require("blink.cmp").get_lsp_capabilities(),
            settings = {
              json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
              },
            },
          })
        end,

        -- Configuración para HTML con Emmet
        ["html"] = function()
          require("lspconfig").html.setup({
            capabilities = require("blink.cmp").get_lsp_capabilities(),
            filetypes = { "html", "templ" },
          })
        end,

        ["emmet_ls"] = function()
          require("lspconfig").emmet_ls.setup({
            capabilities = require("blink.cmp").get_lsp_capabilities(),
            filetypes = {
              "html",
              "typescriptreact",
              "javascriptreact",
              "css",
              "sass",
              "scss",
              "less",
              "vue",
              "svelte",
              "astro",
              "tailwindcss",
            },
          })
        end,

        -- Configuración para Astro
        ["astro"] = function()
          require("lspconfig").astro.setup({
            capabilities = require("blink.cmp").get_lsp_capabilities(),
            filetypes = { "astro" },
            init_options = {
              typescript = {
                tsdk = vim.fn.expand(
                  "$HOME/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib"
                ),
              },
            },
          })
        end,
      },
    },
    config = function(_, opts)
      -- Set up mason-lspconfig with the options
      require("mason-lspconfig").setup(opts)
      -- Remove the setup_handlers call as it's now handled in the opts table
    end,
  },

  -- LSP Config base
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
  },
}

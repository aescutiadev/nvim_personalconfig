-- JavaScript Language Configuration
-- This file contains JavaScript-specific configurations

return {
  -- Extend Treesitter with JavaScript parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "html",
        "css",
      })
      return opts
    end,
  },

  -- Add JavaScript LSP server (vtsls - modern alternative to tsserver)
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.vtsls = {
        -- Automatically detect if it's a JS or TS project
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
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
          },
        },
      }

      return opts
    end,
  },

  -- Ensure Mason installs JavaScript/TypeScript LSP
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "vtsls" })
      return opts
    end,
  },

  -- Add JavaScript formatters
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.javascript = { "prettier" }
      opts.formatters_by_ft.javascriptreact = { "prettier" }
      opts.formatters_by_ft["javascript.jsx"] = { "prettier" }

      opts.formatters = opts.formatters or {}
      opts.formatters.prettier = {
        prepend_args = {
          "--tab-width",
          "2",
          "--single-quote",
          "true",
          "--trailing-comma",
          "es5",
          "--semi",
          "true",
          "--print-width",
          "120",
        },
      }

      return opts
    end,
  },

  -- Add JavaScript linters
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.javascript = { "eslint_d" }
      opts.linters_by_ft.javascriptreact = { "eslint_d" }
      opts.linters_by_ft["javascript.jsx"] = { "eslint_d" }

      return opts
    end,
  },

  -- Ensure Mason tools are installed
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "prettier", -- JavaScript/TypeScript formatter
        "eslint_d", -- Fast ESLint daemon
      })
      return opts
    end,
  },

  -- JavaScript development keybindings
  {
    "folke/which-key.nvim",
    config = function()
      -- Setup JavaScript-specific keymaps when LSP attaches to JS buffers
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local bufname = vim.api.nvim_buf_get_name(event.buf)
          if client and client.name == "vtsls" and (bufname:match("%.js$") or bufname:match("%.jsx$")) then
            local wk = require("which-key")
            wk.add({
              { "<leader>J", group = "javascript", icon = "󰌞", buffer = event.buf },
              { "<leader>Jr", "<cmd>terminal node %<cr>", desc = "Run with Node.js", buffer = event.buf },
              { "<leader>Jn", "<cmd>terminal npm run dev<cr>", desc = "npm run dev", buffer = event.buf },
              { "<leader>Jt", "<cmd>terminal npm test<cr>", desc = "npm test", buffer = event.buf },
              { "<leader>Ji", "<cmd>terminal npm install<cr>", desc = "npm install", buffer = event.buf },
              { "<leader>Jb", "<cmd>terminal npm run build<cr>", desc = "npm run build", buffer = event.buf },
              { "<leader>Js", "<cmd>terminal npm start<cr>", desc = "npm start", buffer = event.buf },
            })
          end
        end,
      })
    end,
  },

  -- Add JavaScript-specific treesitter context patterns
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = function(_, opts)
      opts.patterns = opts.patterns or {}
      opts.patterns.javascript = {
        "function_declaration",
        "method_definition",
        "arrow_function",
        "function_expression",
        "class_declaration",
        "if_statement",
        "for_statement",
        "while_statement",
        "try_statement",
        "switch_statement",
      }
      opts.patterns.javascriptreact = opts.patterns.javascript
      return opts
    end,
  },

  -- Enhanced JavaScript support
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
    },
    opts = {},
  },
}

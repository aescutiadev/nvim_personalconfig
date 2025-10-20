return {
  -- Extiende Treesitter con parsers de Lua
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "lua",
        "luadoc",
        "luap", -- Patrones de Lua
      })
      return opts
    end,
  },

  -- Agrega el servidor LSP de Lua
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Configuración del servidor Lua
      vim.lsp.config("lua_ls", {
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
                "setup",
                "teardown",
                "pending",
                "async",
              },
            },
            workspace = {
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
                "${3rd}/busted/library",
              },
              checkThirdParty = false,
            },
            telemetry = { enable = false },
            completion = { callSnippet = "Replace" },
            format = { enable = false }, -- Usa stylua en su lugar
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

      -- Configuración global de diagnósticos
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      })

      -- Mapeos de teclas LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("<leader>lr", vim.lsp.buf.rename, "LSP Rename")
          map("<leader>la", vim.lsp.buf.code_action, "LSP Code Action")
          map("<leader>lf", vim.lsp.buf.format, "LSP Format")
          map("<leader>lt", vim.lsp.buf.type_definition, "LSP Type Definition")
          map("<leader>li", vim.lsp.buf.implementation, "LSP Implementation")
          map("gO", vim.lsp.buf.document_symbol, "LSP Document Symbols")
        end,
      })
    end,
  },

  -- Formateador: stylua
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.lua = { "stylua" }

      opts.formatters = opts.formatters or {}
      opts.formatters.stylua = {
        prepend_args = function()
          local config_file = vim.fn.findfile("stylua.toml", ".;")
          if config_file ~= "" then
            return { "--config-path", config_file }
          end
          return {
            "--column-width",
            "120",
            "--line-endings",
            "Unix",
            "--indent-type",
            "Spaces",
            "--indent-width",
            "2",
            "--quote-style",
            "AutoPreferDouble",
            "--call-parentheses",
            "Always",
          }
        end,
      }
      return opts
    end,
  },

  -- Linter: luacheck
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.lua = { "luacheck" }

      opts.linters = opts.linters or {}
      opts.linters.luacheck = {
        args = {
          "--globals",
          "vim",
          "--globals",
          "describe",
          "it",
          "before_each",
          "after_each",
          "--codes",
          "--ranges",
          "--formatter",
          "plain",
          "-",
        },
      }
      return opts
    end,
  },

  -- Instalador de herramientas Mason: stylua + luacheck
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "stylua", "luacheck" })
      return opts
    end,
  },

  -- Mapeos de teclas específicos para Lua <leader>L
  {
    "folke/which-key.nvim",
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.name == "lua_ls" then
            local wk = require("which-key")
            wk.add({
              { "<leader>L", group = "lua", icon = "󰢱", buffer = event.buf },
              { "<leader>Lr", "<cmd>luafile %<cr>", desc = "Ejecutar archivo Lua", buffer = event.buf },
              { "<leader>Ls", "<cmd>source %<cr>", desc = "Source archivo Lua", buffer = event.buf },
              { "<leader>Le", ":lua ", desc = "Ejecutar comando Lua", buffer = event.buf },
              {
                "<leader>Lc",
                function()
                  local line = vim.api.nvim_get_current_line()
                  local result = loadstring("return " .. line)()
                  print(vim.inspect(result))
                end,
                desc = "Evaluar línea actual",
                buffer = event.buf,
              },
            })
          end
        end,
      })
    end,
  },

  -- Plugins mejorados para desarrollo en Lua
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },

  -- Definiciones de tipos meta para la plataforma Lua
  { "Bilal2453/luvit-meta", lazy = true },

  -- Contexto de Treesitter para Lua
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = function(_, opts)
      opts.patterns = opts.patterns or {}
      opts.patterns.lua = {
        "function",
        "method",
        "table",
        "if_statement",
        "for_statement",
        "while_statement",
        "repeat_statement",
      }
      return opts
    end,
  },
}

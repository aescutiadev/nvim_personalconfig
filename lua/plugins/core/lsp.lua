return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp", "williamboman/mason-lspconfig.nvim" },
    config = function()
      local lsp = vim.lsp
      local mason_lspconfig = require("mason-lspconfig")

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

      -- Configuraciones específicas por servidor (opcional)
      local server_configs = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
              diagnostics = {
                globals = {
                  "vim",
                  "describe",
                  "it",
                  "before_each",
                  "after_each",
                  "Snacks",
                  "Blink",
                  "snacks",
                  "blink",
                },
              },
              workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
        -- Puedes añadir más servidores aquí si quieres
      }

      -- Para cada servidor instalado con mason-lspconfig
      mason_lspconfig.setup_handlers({
        function(server_name)
          local config = server_configs[server_name] or {}
          -- Añadir capacidades de blink.cmp
          config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities or {})
          -- Configura y habilita el servidor
          lsp.config(server_name, config)
          lsp.enable(server_name)
        end,
      })

      -- Keymaps globales de LSP
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
}

return {
  -- 📦 Schemas para JSON usando schemastore
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- 🌲 Treesitter para JSON
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = vim.tbl_deep_extend("force", opts.ensure_installed or {}, { "json", "jsonc" })
      end
    end,
  },

  -- 🛠 Mason LSP config
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_deep_extend("force", opts.ensure_installed or {}, { "jsonls" })
    end,
  },

  -- 🛠 Mason tool installer
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_deep_extend("force", opts.ensure_installed or {}, { "json-lsp" })
    end,
  },

  -- ⚙ Configuración de LSP nativa para JSON
  {
    "neovim/nvim-lspconfig",
    optional = true,
    config = function()
      local schemastore = require("schemastore")

      -- Configuración del servidor JSON
      vim.lsp.config("jsonls", {
        settings = {
          json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
          },
        },
      })

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

      -- Mapeos de teclas LSP (igual que Lua)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("JsonLspKeymaps", { clear = true }),
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

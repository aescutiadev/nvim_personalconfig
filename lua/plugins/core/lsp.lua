return {
  -- LSP Keymaps y configuración adicional
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazy.core.handler").handlers.keys
      -- Resolver duplicados de keymaps
      if not keys.resolve then
        return {}
      end
      return {
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = " ",
              [vim.diagnostic.severity.WARN] = " ",
              [vim.diagnostic.severity.HINT] = " ",
              [vim.diagnostic.severity.INFO] = " ",
            },
          },
        },
        inlay_hints = {
          enabled = true,
        },
        codelens = {
          enabled = false,
        },
        capabilities = {},
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        servers = {},
        setup = {},
      }
    end,
    config = function(_, opts)
      -- Setup keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts_keymap = { buffer = ev.buf, silent = true }

          -- Navegación
          vim.keymap.set(
            "n",
            "gD",
            vim.lsp.buf.declaration,
            vim.tbl_extend("force", opts_keymap, { desc = "Go to declaration" })
          )
          vim.keymap.set(
            "n",
            "gd",
            vim.lsp.buf.definition,
            vim.tbl_extend("force", opts_keymap, { desc = "Go to definition" })
          )
          vim.keymap.set(
            "n",
            "gi",
            vim.lsp.buf.implementation,
            vim.tbl_extend("force", opts_keymap, { desc = "Go to implementation" })
          )
          vim.keymap.set(
            "n",
            "gr",
            vim.lsp.buf.references,
            vim.tbl_extend("force", opts_keymap, { desc = "Show references" })
          )
          vim.keymap.set(
            "n",
            "gt",
            vim.lsp.buf.type_definition,
            vim.tbl_extend("force", opts_keymap, { desc = "Go to type definition" })
          )

          -- Información
          vim.keymap.set(
            "n",
            "K",
            vim.lsp.buf.hover,
            vim.tbl_extend("force", opts_keymap, { desc = "Hover documentation" })
          )
          vim.keymap.set(
            "n",
            "<C-k>",
            vim.lsp.buf.signature_help,
            vim.tbl_extend("force", opts_keymap, { desc = "Signature help" })
          )
          vim.keymap.set(
            "i",
            "<C-k>",
            vim.lsp.buf.signature_help,
            vim.tbl_extend("force", opts_keymap, { desc = "Signature help" })
          )

          -- Acciones de código
          vim.keymap.set(
            { "n", "v" },
            "<leader>ca",
            vim.lsp.buf.code_action,
            vim.tbl_extend("force", opts_keymap, { desc = "Code action" })
          )
          vim.keymap.set(
            "n",
            "<leader>rn",
            vim.lsp.buf.rename,
            vim.tbl_extend("force", opts_keymap, { desc = "Rename symbol" })
          )

          -- Diagnósticos
          vim.keymap.set(
            "n",
            "<leader>d",
            vim.diagnostic.open_float,
            vim.tbl_extend("force", opts_keymap, { desc = "Show line diagnostics" })
          )
          vim.keymap.set(
            "n",
            "[d",
            vim.diagnostic.goto_prev,
            vim.tbl_extend("force", opts_keymap, { desc = "Previous diagnostic" })
          )
          vim.keymap.set(
            "n",
            "]d",
            vim.diagnostic.goto_next,
            vim.tbl_extend("force", opts_keymap, { desc = "Next diagnostic" })
          )
          vim.keymap.set(
            "n",
            "<leader>cq",
            vim.diagnostic.setloclist,
            vim.tbl_extend("force", opts_keymap, { desc = "Add diagnostics to location list" })
          )

          -- TypeScript específicos (solo para archivos TS/JS)
          local filetype = vim.bo[ev.buf].filetype
          if
            filetype == "typescript"
            or filetype == "javascript"
            or filetype == "typescriptreact"
            or filetype == "javascriptreact"
          then
            vim.keymap.set(
              "n",
              "<leader>to",
              "<cmd>TSLspOrganizeImports<cr>",
              vim.tbl_extend("force", opts_keymap, { desc = "Organize imports" })
            )
            vim.keymap.set(
              "n",
              "<leader>tR",
              "<cmd>TSLspRenameFile<cr>",
              vim.tbl_extend("force", opts_keymap, { desc = "Rename file" })
            )
            vim.keymap.set(
              "n",
              "<leader>ti",
              "<cmd>TSLspImportAll<cr>",
              vim.tbl_extend("force", opts_keymap, { desc = "Import all missing imports" })
            )
          end

          -- Inlay hints toggle
          if vim.lsp.inlay_hint then
            vim.keymap.set("n", "<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, vim.tbl_extend("force", opts_keymap, { desc = "Toggle inlay hints" }))
          end
        end,
      })

      -- Configurar diagnósticos
      vim.diagnostic.config(opts.diagnostics)

      -- Configurar signos
      for severity, icon in pairs(opts.diagnostics.signs.text) do
        local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      -- Configurar borders para floating windows
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "rounded"
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end
    end,
  },
}

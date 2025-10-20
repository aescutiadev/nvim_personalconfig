return {
  -- Extiende Treesitter con parsers para TypeScript y frameworks
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "typescript",
        "tsx",
        "jsdoc",
        "json",
        "jsonc",
        "html",
        "css",
        "scss",
        "vue",
        "astro",
      })
      return opts
    end,
  },

  -- Agrega el servidor LSP de TypeScript
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- Configuración del servidor ts_ls
      opts.servers.ts_ls = {
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = vim.fn.stdpath("data")
                .. "/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin",
            },
          },
        },
        filetypes = {
          "typescript",
          "javascript",
          "javascriptreact",
          "typescriptreact",
          "typescript.tsx",
          "vue",
          "astro",
        },
        settings = {
          complete_function_calls = true,
        },
      }

      return opts
    end,
  },

  -- Instalador de herramientas Mason: prettier, eslint_d y vue-language-server
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "prettier",
        "eslint_d",
        "vue-language-server",
      })
      return opts
    end,
  },

  -- Formateador: prettier
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.typescript = { "prettier" }
      opts.formatters_by_ft.typescriptreact = { "prettier" }
      opts.formatters_by_ft["typescript.tsx"] = { "prettier" }
      opts.formatters_by_ft.vue = { "prettier" }
      opts.formatters_by_ft.astro = { "prettier" }

      opts.formatters = opts.formatters or {}
      opts.formatters.prettier = opts.formatters.prettier
        or {
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
            "100",
            "--plugin",
            "prettier-plugin-astro",
          },
        }

      return opts
    end,
  },

  -- Linter: eslint_d
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.typescript = { "eslint_d" }
      opts.linters_by_ft.typescriptreact = { "eslint_d" }
      opts.linters_by_ft["typescript.tsx"] = { "eslint_d" }
      opts.linters_by_ft.vue = { "eslint_d" }
      opts.linters_by_ft.astro = { "eslint_d" }

      return opts
    end,
  },

  -- Mapeos de teclas específicos para TypeScript <leader>T
  {
    "folke/which-key.nvim",
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local ft = vim.bo[event.buf].filetype

          if client and client.name == "ts_ls" then
            local wk = require("which-key")
            local group_name = "typescript"
            local icon = "󰛦"

            if ft == "vue" then
              group_name = "vue"
              icon = "󰡄"
            elseif ft == "astro" then
              group_name = "astro"
              icon = "󱓞"
            end

            wk.add({
              { "<leader>T", group = group_name, icon = icon, buffer = event.buf },
              { "<leader>Tr", "<cmd>terminal tsx %<cr>", desc = "Run with tsx", buffer = event.buf },
              { "<leader>Tc", "<cmd>terminal tsc --noEmit<cr>", desc = "Type check", buffer = event.buf },
              { "<leader>Tb", "<cmd>terminal tsc<cr>", desc = "Build/Compile", buffer = event.buf },
              { "<leader>Tn", "<cmd>terminal npm run dev<cr>", desc = "npm run dev", buffer = event.buf },
              { "<leader>Tt", "<cmd>terminal npm test<cr>", desc = "npm test", buffer = event.buf },
              { "<leader>Ti", "<cmd>terminal npm install<cr>", desc = "npm install", buffer = event.buf },
              { "<leader>Ts", "<cmd>terminal npm start<cr>", desc = "npm start", buffer = event.buf },
            })

            if ft == "vue" or ft == "astro" then
              wk.add({
                { "<leader>Tv", "<cmd>terminal npm run build<cr>", desc = "Build (Vue/Astro)", buffer = event.buf },
              })
            end

            if ft == "astro" then
              wk.add({
                { "<leader>Ta", "<cmd>terminal npm run astro dev<cr>", desc = "Astro dev server", buffer = event.buf },
              })
            end
          end
        end,
      })
    end,
  },

  -- Contexto de Treesitter para TypeScript
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = function(_, opts)
      opts.patterns = opts.patterns or {}
      local ts_patterns = {
        "function_declaration",
        "method_definition",
        "arrow_function",
        "function_expression",
        "class_declaration",
        "interface_declaration",
        "type_alias_declaration",
        "enum_declaration",
        "namespace_declaration",
        "module_declaration",
        "if_statement",
        "for_statement",
        "while_statement",
        "try_statement",
        "switch_statement",
      }

      opts.patterns.typescript = ts_patterns
      opts.patterns.typescriptreact = ts_patterns
      opts.patterns.vue = vim.list_extend(vim.deepcopy(ts_patterns), {
        "script_element",
        "template_element",
        "style_element",
      })
      opts.patterns.astro = vim.list_extend(vim.deepcopy(ts_patterns), {
        "frontmatter",
        "astro_element",
      })

      return opts
    end,
  },

  -- Autotags para TypeScript y frameworks
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = {
      "html",
      "css",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "astro",
    },
    opts = {},
  },

  -- Utilidades específicas para TypeScript
  {
    "marilari88/twoslash-queries.nvim",
    ft = { "typescript", "typescriptreact", "vue", "astro" },
    opts = {
      multi_line = true,
      is_enabled = true,
    },
    keys = {
      {
        "<leader>tq",
        "<cmd>TwoslashQueriesInspect<cr>",
        desc = "Twoslash Query",
        ft = { "typescript", "typescriptreact", "vue", "astro" },
      },
    },
  },

  -- Mejoras para Vue
  {
    "posva/vim-vue",
    ft = "vue",
  },

  -- Mejoras para Astro
  {
    "wuelnerdotexe/vim-astro",
    ft = "astro",
    init = function()
      vim.filetype.add({
        extension = {
          astro = "astro",
        },
      })
    end,
  },
}

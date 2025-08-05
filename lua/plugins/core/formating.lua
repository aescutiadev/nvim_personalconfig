return {
  -- Conform.nvim - Formateo de código
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        jsonc = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        scss = { "prettierd", "prettier" },
        sass = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
        vue = { "prettierd", "prettier" },
        svelte = { "prettierd", "prettier" },
        astro = { "prettierd", "prettier" }, -- Add Astro formatting
      },
      default_format_opts = {
        lsp_fallback = true,
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters = {
        stylua = {
          prepend_args = {
            "--column-width", "100",
            "--line-endings", "Unix",
            "--indent-type", "Spaces",
            "--indent-width", "2",
            "--quote-style", "AutoPreferDouble",
          },
        },
        prettierd = {
          env = {
            PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.prettierrc.json"),
          },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  -- Mason Tool Installer - Para instalar tools automáticamente
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        -- Formatters
        "stylua",    -- Lua formatter
        "prettierd", -- Prettier daemon (más rápido)
        "prettier",  -- Prettier fallback

        -- Linters
        "eslint_d", -- ESLint daemon
        "luacheck", -- Lua linter

        -- LSP servers (redundante con mason-lspconfig, pero por si acaso)
        "lua-language-server",
        "vtsls",
        "eslint-lsp",
        "json-lsp",
        "html-lsp",
        "css-lsp",
        "emmet-ls",
        "astro-language-server", -- Astro Language Server
      },
      auto_update = true,
      run_on_start = true,
      start_delay = 3000, -- 3 second delay
    },
  },
}

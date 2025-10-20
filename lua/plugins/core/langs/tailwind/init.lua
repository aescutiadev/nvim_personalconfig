return {
  -- Treesitter: asegura soporte para HTML, CSS y frameworks tipo styled-components
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}

      local parsers = { "html", "css", "scss", "javascript", "typescript", "tsx" }
      for _, lang in ipairs(parsers) do
        if not vim.tbl_contains(opts.ensure_installed, lang) then
          table.insert(opts.ensure_installed, lang)
        end
      end
    end,
  },

  -- Mason LSP Config: instala los LSP necesarios para frontend + Tailwind
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}

      local servers = { "html", "cssls", "emmet_ls", "tailwindcss" }
      for _, s in ipairs(servers) do
        if not vim.tbl_contains(opts.ensure_installed, s) then
          table.insert(opts.ensure_installed, s)
        end
      end
    end,
  },

  -- Mason Tool Installer: sincroniza herramientas externas (lenguaje, formatters, etc.)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}

      local tools = {
        "html-lsp",
        "css-lsp",
        "emmet-ls",
        "tailwindcss-language-server",
        "prettier",
      }

      for _, tool in ipairs(tools) do
        if not vim.tbl_contains(opts.ensure_installed, tool) then
          table.insert(opts.ensure_installed, tool)
        end
      end
    end,
  },

  -- Colorizer: para ver colores inline (soporta clases Tailwind)
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        names = true,
        tailwind = true,
      },
    },
  },

  -- Ícono para archivos postcss (puro visual)
  {
    "echasnovski/mini.icons",
    opts = {
      filetype = {
        postcss = { glyph = "󰌜", hl = "MiniIconsOrange" },
      },
    },
  },
}

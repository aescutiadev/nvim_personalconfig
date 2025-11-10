return {
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
  -- tailwind-tools.lua
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    optional = true,
    opts = {
      names = true,
      tailwind = true,
    },
  },
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = {
        "markdown",
        "markdown_inline",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        "marksman",
        "mdx_analyzer",
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        "marksman",
        "mdx_analyzer",
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    cmd = "RenderMarkdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = function()
      local plugin = require("lazy.core.config").spec.plugins["render-markdown.nvim"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      return opts.file_types or { "markdown" }
    end,
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}

return {

  -- tailwind-tools.lua
  -- {
  --   "luckasRanarison/tailwind-tools.nvim",
  --   name = "tailwind-tools",
  --   build = ":UpdateRemotePlugins",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "folke/snacks.nvim",
  --     "neovim/nvim-lspconfig",
  --   },
  --   opts = {
  --     document_color = {
  --       enabled = true,
  --       kind = "inline",
  --     },
  --     hover = true,
  --   },
  -- },
  {
    "razak17/tailwind-fold.nvim",
    opts = {
      min_chars = 50,
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "html", "svelte", "astro", "vue", "typescriptreact" },
  },

  {
    "MaximilianLloyd/tw-values.nvim",
    keys = {
      { "<Leader>cv", "<CMD>TWValues<CR>", desc = "Tailwind CSS values" },
    },
    opts = {
      border = "rounded",         -- Valid window border style,
      show_unknown_classes = true -- Shows the unknown classes popup
    }
  },
}

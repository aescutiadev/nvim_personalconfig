return {
  {
    "AstroNvim/astrotheme",
    opts = {
      style = {
        transparent = true, -- enable transparent background
        inactive = false,   -- enable inactive window transparency
        border = true,      -- enable border transparency
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      transparent = true,
      border = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_highlights = function(hl, _)
        hl.CursorLine = {
          bg = "#0d1117", -- #1c1c1c #0d1117 #0d1117
        }
      end,
      -- style = "night",
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}

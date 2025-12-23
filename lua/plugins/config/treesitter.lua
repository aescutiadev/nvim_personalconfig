local treesitter = {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,        -- ❗ NO soporta lazy-loading
  build = ":TSUpdate", -- obligatorio
  config = function()
    -- SOLO cosas del manager
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Parsers a instalar
    require("nvim-treesitter").install({
      "lua",
      "regex",
      "python",
      "javascript",
      "typescript",
      "json",
      "html",
      "css",
      "rust",
      "markdown",
      "bash",
      "yaml",
      "toml",
      "norg",
    })
  end,
}

return treesitter

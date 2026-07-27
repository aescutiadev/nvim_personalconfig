vim.pack.add({
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = 'https://github.com/nvim-mini/mini.icons' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/ellisonleao/dotenv.nvim" },
})

require("mason").setup()

require("nvim-web-devicons").setup({
  override_by_extension = {
    css = { icon = "󰌜", color = "#42a5f5", name = "Css" },
    postcss = { icon = "󰌜", color = "#e65100", name = "PostCss" },
    yml = { icon = "󰈙", color = "#cb171e", name = "Yml" },
    yaml = { icon = "󰈙", color = "#cb171e", name = "Yaml" },
  },
})

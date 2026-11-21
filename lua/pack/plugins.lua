vim.pack.add({
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/mason-org/mason.nvim" },
})

require("nvim-web-devicons").setup({
  override_by_extension = {
    css = { icon = "󰌜", color = "#42a5f5", name = "Css" },
    postcss = { icon = "󰌜", color = "#e65100", name = "PostCss" },
    yml = { icon = "󰈙", color = "#cb171e", name = "Yml" },
    yaml = { icon = "󰈙", color = "#cb171e", name = "Yaml" },
  },
})

-- Mason es un instalador de herramientas: no hace falta en el camino crítico.
-- Pero su bin/ tiene que estar en PATH ANTES de que config/lsp.lua verifique
-- qué servidores existen, así que el PATH se agrega acá y el setup se difiere.
local mason_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin")
if vim.fn.isdirectory(mason_bin) == 1 and not (vim.env.PATH or ""):find(mason_bin, 1, true) then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

require("config.defer").run("mason", function()
  require("mason").setup()
end)

vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-mini/mini.nvim',   -- if you use the mini.nvim suite
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
})

-- render-markdown.nvim/plugin/render-markdown.lua hace setup() solo al arrancar
-- leyendo este global. Configurar por acá evita un segundo setup() y una
-- carrera con el plugin file. (Diferirlo de verdad exigiría pisar
-- vim.g.loaded_render_markdown y replicar sus init() internos: frágil.)
vim.g.render_markdown_config = {
  completions = { lsp = { enabled = true } },
}

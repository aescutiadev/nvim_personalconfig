-- Configurar capabilities y handlers
require("lsp.capabilities").setup()
require("lsp.handlers").setup()

-- Habilitar servidores LSP instalados con Mason
vim.lsp.enable("lua_ls")
vim.lsp.enable("vtsls")
vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.enable("css_variables")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("marksman")
vim.lsp.enable("astro")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("taplo")
vim.lsp.enable("yamlls")
vim.lsp.enable("jsonls")
vim.lsp.enable("bashls")

vim.pack.add({ "https://github.com/mason-org/mason.nvim" })

vim.cmd.packadd("mason.nvim")

require("plugins.editor.mason-org.config")
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

vim.cmd.packadd("nvim-treesitter")

require("editor.treesitter").setup()
vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/echasnovski/mini.icons",
})

vim.cmd.packadd("nvim-web-devicons")
vim.cmd.packadd("mini.icons")
require("plugins.editor.treesitter")
require("plugins.editor.mason-org")
require("plugins.ui.neotree")
require("plugins.ui.whichkey")
require("plugins.ui.snacks")

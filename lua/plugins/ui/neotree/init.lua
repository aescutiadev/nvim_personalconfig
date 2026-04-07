vim.pack.add({
  {
    src = 'https://github.com/nvim-neo-tree/neo-tree.nvim',
    version = vim.version.range('3')
  },
  -- dependencies
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

vim.pack.add({
  "https://github.com/antosha417/nvim-lsp-file-operations",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

vim.pack.add({
  { src = "https://github.com/s1n7ax/nvim-window-picker", version = vim.version.range('2') },
})

vim.cmd.packadd("plenary.nvim")
vim.cmd.packadd("nui.nvim")
vim.cmd.packadd("nvim-web-devicons")
vim.cmd.packadd("nvim-window-picker")
vim.cmd.packadd("nvim-lsp-file-operations")
vim.cmd.packadd("neo-tree.nvim")

require("plugins.ui.neotree.config")
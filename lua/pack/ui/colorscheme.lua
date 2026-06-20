vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })

require("tokyonight").setup({
  transparent = true,
  styles = {
    sidebars = "transparent", -- neo-tree, splits laterales
    floats = "transparent",   -- ventanas flotantes (winborder rounded que tenés)
  },
})

vim.cmd.colorscheme("tokyonight")

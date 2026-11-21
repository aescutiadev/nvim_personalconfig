vim.pack.add({
  {
    src = "https://github.com/eero-lehtinen/oklch-color-picker.nvim",
    version = vim.version.range("*"),
  },
})

-- El keymap hace require on-demand, así que el setup puede esperar al idle.
require("config.defer").run("oklch-color-picker", function()
  require("oklch-color-picker").setup({})
end)

vim.keymap.set("n", "<leader>v", function()
  require("oklch-color-picker").pick_under_cursor()
end, { desc = "Color pick under cursor" })

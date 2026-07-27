vim.pack.add({
  {
    src = "https://github.com/saecki/crates.nvim",
  },
}, {
  load = false,
})

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "Cargo.toml",
  once = true,
  callback = function()
    vim.cmd.packadd("crates.nvim")

    require("crates").setup({
      completion = {
        cmp = { enabled = false },
        crates = { enabled = true },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    })
  end,
})

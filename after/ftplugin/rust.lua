local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
  "n",
  "<leader>ca",
  function()
    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
    -- or vim.lsp.buf.codeAction() if you don't want grouping.
  end,
  { silent = true, buffer = bufnr, desc = "Rust Code Action" }
)
vim.keymap.set(
  "n",
  "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
  function()
    vim.cmd.RustLsp({ 'hover', 'actions' })
  end,
  { silent = true, buffer = bufnr }
)

vim.g.rustaceanvim = {
  -- LSP configuration
  server = {
    default_settings = {
      -- rust-analyzer language server configuration
      ['rust-analyzer'] = {
        cargo = {
          features = "all", -- Enable all features
        },
        lens = {
          debug = { enable = true },
          enable = true,
          implementations = { enable = true },
          references = {
            adt = { enable = true },
            enumVariant = { enable = true },
            method = { enable = true },
            trait = { enable = true },
          },
          run = { enable = true },
          updateTest = { enable = true },
        },
        procMacro = {
          ignored = {
            leptos_macro = {
              -- optional: --
              -- "component",
              "server",
            },
          },
        },
      },
    },
  },
}

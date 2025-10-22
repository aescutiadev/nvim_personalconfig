-- lsp
--------------------------------------------------------------------------------
-- See https://gpanders.com/blog/whats-new-in-neovim-0-11/ for a nice overview
-- of how the lsp setup works in neovim 0.11+.

-- This actually just enables the lsp servers.
-- The configuration is found in the lsp folder inside the nvim config folder,
-- so in ~.config/lsp/lua_ls.lua for lua_ls, for example.
-- Habilitar servidores LSP
vim.lsp.enable('lua_ls')
vim.lsp.enable('vtsls')
vim.lsp.enable('astro')
vim.lsp.enable('tailwindcss')
vim.lsp.enable('mdx_analyzer')
vim.lsp.enable('marksman')
vim.lsp.enable('html')

-- Configuración de autocompletado
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      vim.keymap.set('i', '<C-Space>', function()
        vim.lsp.completion.get()
      end)
    end
  end,
})

-- Formateo al guardar
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
  callback = function(args)
    local buf = args.buf
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = false }),
      buffer = buf,
      callback = function()
        vim.lsp.buf.format({ bufnr = buf, async = false })
      end,
    })
  end,
})

-- Configuración de diagnósticos
vim.diagnostic.config({
  -- virtual_lines = { current_line = true },
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '󰌵',
    },
  }
})

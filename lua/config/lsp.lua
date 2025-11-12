-- lsp.lua - Neovim 0.11+ LSP + Completado perfecto

-- Setea completeopt para un completado óptimo (menu con al menos un item, sin selección automática)
vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }

-- Habilitar LSPs (usa vim.lsp.enable para auto-activar basado en filetypes/root_markers)
vim.lsp.enable('lua_ls')
vim.lsp.enable('vtsls')
vim.lsp.enable('astro')
vim.lsp.enable('tailwindcss')
vim.lsp.enable('mdx_analyzer')
vim.lsp.enable('marksman')
vim.lsp.enable('html')

-- Capabilities globales para TODOS los clientes (extiende defaults)
vim.lsp.config('*', {
  capabilities = vim.tbl_deep_extend(
    'force',
    vim.lsp.protocol.make_client_capabilities(), -- Defaults de Neovim
    {
      textDocument = {
        completion = {
          completionItem = {
            documentationFormat = { 'markdown', 'plaintext' },                  -- Soporte para docs en markdown
            snippetSupport = true,                                              -- Snippets (asegura integración con luasnip/vsnip si lo usas)
            resolveSupport = {
              properties = { 'documentation', 'detail', 'additionalTextEdits' } -- Resolve lazy (details/docs/edits)
            },
            labelDetailsSupport = true,                                         -- Muestra details en labels del menú
          }
        }
      }
    }
  )
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {
    border = "rounded",
    title = " Documentation ",
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {
    border = "rounded",
    title = " Signature ",
  }
)

-- === LSP ATTACH ===
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', { clear = true }), -- Clear=true para evitar duplicados
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf

    -- Habilitar completado LSP (con autotrigger basado en triggerCharacters del server)
    if client:supports_method('textDocument/completion') then
      -- Opcional: Trigger en CADA tecla (puede ser lento; pruébalo y comenta si no lo quieres)
      local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      client.server_capabilities.completionProvider.triggerCharacters = chars

      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end

    -- Formateo automático en save (solo si no soporta willSaveWaitUntil)
    if not client:supports_method('textDocument/willSaveWaitUntil') and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp.format', { clear = false }),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 1000, async = false }) -- Síncrono para save
        end,
      })
    end

    -- Keymaps buffer-local (útiles para LSP)
    local opts = { buffer = bufnr, desc = 'LSP: ' }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to Definition' }))
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'Go to Declaration' }))
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
      vim.tbl_extend('force', opts, { desc = 'Go to Implementation' }))
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'References' }))
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover Documentation' }))
    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename' }))
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action,
      vim.tbl_extend('force', opts, { desc = 'Code Action' }))
    vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'Signature Help' })) -- En insert mode
  end,
})

-- Configuración de diagnósticos
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = 'if_many',
    prefix = '●',
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
      [vim.diagnostic.severity.HINT] = '󰌵 ',
    },
  },
})

-- Keymaps globales para diagnósticos
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Float Diagnostic' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev Diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
vim.keymap.set('n', '<leader>cl', vim.diagnostic.setloclist, { desc = 'Diagnostic Loclist' })

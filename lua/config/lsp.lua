-- lsp.lua - Neovim 0.11+ LSP + Completado perfecto

-- Setea completeopt para un completado óptimo (menu con al menos un item, sin selección automática)
vim.opt.completeopt = { 'menuone', 'noselect', 'popup' } -- Recomendado por doc para LSP completion

-- Habilitar LSPs (usa vim.lsp.enable para auto-activar basado en filetypes/root_markers)
vim.lsp.enable('lua_ls')
vim.lsp.enable('astro')
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
        semanticTokens = {
          multilineTokenSupport = true,
        },
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

-- === LSP ATTACH ===
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf

    local INLAY_HINTS_DISABLED_FT = {
      lua = true,
      markdown = true,
      toml = true,
      help = true,
    }

    -- Habilitar completado autotrigger
    if client:supports_method('textDocument/completion') then
      local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      client.server_capabilities.completionProvider.triggerCharacters = chars
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end

    -- Inlay Hints
    if client and client.server_capabilities.inlayHintProvider then
      if not INLAY_HINTS_DISABLED_FT[vim.bo[bufnr].filetype] then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end

    -- Formatting on save
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp.format', { clear = false }),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            id = client.id,
            timeout_ms = 1000,
            async = false,
          })
        end,
      })
    end

    -- Keymaps LSP
    local opts = { buffer = bufnr, desc = 'LSP: ' }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to Definition' }))
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'Go to Declaration' }))
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
      vim.tbl_extend('force', opts, { desc = 'Go to Implementation' }))
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'References' }))
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover Documentation' }))
    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename' }))
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action,
      vim.tbl_extend('force', opts, { desc = 'Code Action' }))
    vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'Signature Help' }))
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

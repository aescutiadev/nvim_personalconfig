-- lsp.lua - Neovim 0.11+ LSP configuration
-- Note: LspAttach autocmd is now handled in blink-cmp.lua plugin

-- LSP DIAGNOSTICS CONFIG

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
      [vim.diagnostic.severity.WARN]  = ' ',
      [vim.diagnostic.severity.INFO]  = ' ',
      [vim.diagnostic.severity.HINT]  = '󰌵',
    },
  },
})

vim.lsp.semantic_tokens.enable = true

-- LSP ATTACH
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('blink.lsp', { clear = true }),

  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf

    -- INLAY HINTS
    local DISABLED = { lua = true, markdown = true, toml = true, help = true }

    if client.server_capabilities.inlayHintProvider then
      if not DISABLED[vim.bo[bufnr].filetype] then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end

    -- FORMAT ON SAVE
    if client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('blink.lsp.format', { clear = false }),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            id = client.id,
            timeout_ms = 1000,
            async = false,
          })
        end
      })
    end

    -- LSP KEYMAPS
    local map = function(mode, keys, fn, desc)
      vim.keymap.set(mode, keys, fn, { buffer = bufnr, desc = desc })
    end

    map('n', 'gd', vim.lsp.buf.definition, 'LSP: Go to Definition')
    map('n', 'gD', vim.lsp.buf.declaration, 'LSP: Go to Declaration')
    map('n', 'gi', vim.lsp.buf.implementation, 'LSP: Go to Implementation')
    map('n', 'K', vim.lsp.buf.hover, 'LSP: Hover Documentation')
    map('n', '<leader>cr', vim.lsp.buf.rename, 'LSP: Rename')
    map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'LSP: Code Action')
    map('i', '<C-s>', vim.lsp.buf.signature_help, 'LSP: Signature Help')
  end,
})

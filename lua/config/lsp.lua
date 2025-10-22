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

      -- Mostrar diagnóstico flotante de la línea actual
      vim.keymap.set('n', '<leader>cd', function()
        vim.diagnostic.open_float(nil, {
          focusable = true, -- no permite enfocar la ventana
          -- close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          border = "rounded", -- borde redondeado
          source = "always", -- mostrar la fuente del diagnóstico
          prefix = '●', -- símbolo inicial
        })
      end, { desc = "Show definition", noremap = true, silent = true })

      -- Mostrar todos los diagnósticos de todos los buffers en Quickfix List
      vim.keymap.set('n', '<leader>ca', function()
        local diagnostics = {}

        -- Recorre todos los buffers cargados
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) then
            for _, diag in ipairs(vim.diagnostic.get(buf)) do
              table.insert(diagnostics, diag)
            end
          end
        end

        -- Convierte diagnósticos a items de Quickfix
        local items = vim.diagnostic.toqflist(diagnostics)

        -- Envía a Quickfix List usando la API oficial
        vim.diagnostic.setqflist({ items = items, open = true, title = "All Diagnostics" })
      end, { desc = "Show all diagnostics in Quickfix", noremap = true, silent = true })

      -- Keymap para "Inspect" (hover sobre el símbolo)
      vim.keymap.set('n', '<leader>ci', function()
        vim.lsp.buf.hover({
          border = "rounded",
          max_width = 80,
          focusable = false
        })
      end, { desc = "Show Inspect", noremap = true, silent = true })

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

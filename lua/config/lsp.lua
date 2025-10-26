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

-- Configuración global para mostrar más información en el autocompletado
vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          -- Mostrar documentación en el autocompletado
          documentationFormat = { 'markdown', 'plaintext' },
          snippetSupport = true,
          resolveSupport = {
            properties = { 'documentation', 'detail', 'additionalTextEdits' }
          },
          -- Mostrar información detallada
          labelDetailsSupport = true,
        }
      }
    }
  }
})

-- Configuración de autocompletado
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      -- Configuración optimizada con preview para ver documentación
      vim.opt_local.completeopt = { 'menu', 'menuone', 'noselect', 'preview' }

      -- Habilitar autocompletado con más información
      vim.lsp.completion.enable(true, client.id, ev.buf, {
        autotrigger = true,
      })

      -- Mostrar información detallada en la ventana de preview automáticamente
      vim.api.nvim_create_autocmd('CompleteChanged', {
        buffer = ev.buf,
        callback = function()
          local info = vim.fn.complete_info({ 'selected', 'items' })
          if info.selected ~= -1 and info.items and info.items[info.selected + 1] then
            local item = info.items[info.selected + 1]

            -- Si hay documentación o información adicional, mostrarla
            if item.info and item.info ~= '' then
              -- Cerrar preview anterior (corregido)
              pcall(function() vim.cmd('pclose') end)

              -- Crear preview con la información
              local lines = vim.split(item.info, '\n')

              -- Crear preview window (corregido)
              pcall(function()
                vim.cmd('pedit +setlocal\\ buftype=nofile\\ bufhidden=wipe\\ noswapfile\\ nobuflisted [Completion-Info]')
              end)

              local preview_win = vim.fn.bufwinid('[Completion-Info]')
              if preview_win ~= -1 then
                local preview_buf = vim.fn.winbufnr(preview_win)
                vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, lines)
                vim.api.nvim_set_option_value('wrap', true, { win = preview_win })
                vim.api.nvim_set_option_value('linebreak', true, { win = preview_win })
                vim.api.nvim_set_option_value('number', false, { win = preview_win })
                vim.api.nvim_set_option_value('relativenumber', false, { win = preview_win })
              end
            end
          end
        end,
      })

      -- Keymaps para controlar el autocompletado
      local opts = { buffer = ev.buf, noremap = true, silent = true }

      -- Aceptar con <CR> (Enter)
      vim.keymap.set('i', '<CR>', function()
        if vim.fn.pumvisible() == 1 then
          -- Cerrar preview al aceptar
          pcall(function() vim.cmd('pclose') end)
          return '<C-y>'
        else
          return '<CR>'
        end
      end, { buffer = ev.buf, expr = true, noremap = true })

      -- Cancelar solo con <Esc>
      vim.keymap.set('i', '<Esc>', function()
        -- Cerrar preview siempre
        pcall(function() vim.cmd('pclose') end)
        if vim.fn.pumvisible() == 1 then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-e><Esc>', true, false, true), 'n')
        else
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n')
        end
      end, opts)

      -- Evitar que Backspace cierre el popup
      vim.keymap.set('i', '<BS>', function()
        if vim.fn.pumvisible() == 1 then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<BS>', true, false, true), 'n', false)
          vim.defer_fn(function()
            if vim.fn.mode() == 'i' and vim.fn.pumvisible() == 0 then
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true), 'n', false)
            end
          end, 50)
          return ''
        else
          return '<BS>'
        end
      end, { buffer = ev.buf, expr = true, noremap = true })

      -- Forzar activación manual
      vim.keymap.set('i', '<C-Space>', function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true), 'n', false)
      end, opts)

      -- Mostrar diagnóstico flotante de la línea actual
      vim.keymap.set('n', '<leader>cd', function()
        vim.diagnostic.open_float(nil, {
          focusable = true,
          border = "rounded",
          source = "always",
          prefix = '●',
        })
      end, { desc = "Show definition", noremap = true, silent = true })

      -- Mostrar todos los diagnósticos de todos los buffers en Quickfix List
      vim.keymap.set('n', '<leader>ca', function()
        local diagnostics = {}
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) then
            for _, diag in ipairs(vim.diagnostic.get(buf)) do
              table.insert(diagnostics, diag)
            end
          end
        end
        local items = vim.diagnostic.toqflist(diagnostics)
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

-- Función auxiliar para crear grupos de autocmd
local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

vim.api.nvim_create_autocmd("CompleteChanged", {
  group = augroup("PmenuBorderColor"),
  callback = function()
    local pumvisible = vim.fn.pumvisible()
    if pumvisible == 1 then
      vim.cmd('highlight PmenuBorder guifg=#555555')
      vim.cmd('redraw')
    end
  end
})

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params
        .value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return vim.notify_once(
        "[LSP Progress] clint not found or invalid value",
        "warn",
        { title = "LSP Progress" }
      )
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), "info", {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
            or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

-- Iniciar Tree-sitter al abrir un archivo (excepto bigfiles)
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    if vim.b[args.buf].bigfile then
      return
    end
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- 1. Recargar archivos si cambiaron fuera de Neovim
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- 2. Resaltar texto al hacer yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- 3. Ajustar splits cuando cambia el tamaño de la ventana
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- 4. Volver a la última posición al abrir un buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 5. Cerrar con "q" en ciertos tipos de buffer
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, { buffer = event.buf, silent = true, desc = "Cerrar buffer" })
    end)
  end,
})

-- 6. Buffers man sin listar
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- 7. Activar wrap y spell para archivos de texto
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- 8. Mostrar todo el contenido en JSON (conceallevel = 0)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- 9. Crear directorios automáticamente al guardar
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- 10. Copiar al clipboard del sistema al hacer yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("yank_to_clipboard", { clear = true }),
  callback = function()
    if vim.v.event.operator == "y" and vim.v.event.regname == "" then
      vim.fn.setreg("+", vim.fn.getreg('"'))
    end
  end,
})

-- 11. Quitar resaltado de búsqueda al presionar ESC
vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = augroup("clear_search_highlight"),
  callback = function()
    vim.schedule(function()
      vim.cmd("nohlsearch")
    end)
  end,
})

-- 12. Aplicar estado global de inlay hints a nuevos buffers con LSP
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("inlay_hints_global"),
  callback = function(event)
    if vim.g.inlay_hints_enabled then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end
  end,
})

-- 13. Format on save (controlado por vim.g.format_on_save)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("format_on_save"),
  callback = function(event)
    if not vim.g.format_on_save then
      return
    end
    local clients = vim.lsp.get_clients({ bufnr = event.buf, method = "textDocument/formatting" })
    if #clients > 0 then
      vim.lsp.buf.format({ bufnr = event.buf, timeout_ms = 3000 })
    end
  end,
})

-- 13. Optimización para archivos grandes (>1MB)
vim.api.nvim_create_autocmd("BufReadPre", {
  group = augroup("bigfile"),
  callback = function(ev)
    local file = ev.match
    local stat = vim.uv.fs_stat(file)
    if not stat or stat.size <= 1024 * 1024 then
      return
    end

    vim.b[ev.buf].bigfile = true

    -- Desactivar syntax y treesitter
    vim.api.nvim_create_autocmd("BufReadPost", {
      buffer = ev.buf,
      once = true,
      callback = function()
        vim.cmd("syntax clear")
        vim.opt_local.syntax = ""
        pcall(vim.treesitter.stop, ev.buf)
      end,
    })

    -- Desactivar features costosas
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.foldexpr = ""
    vim.opt_local.spell = false
    vim.opt_local.list = false
    vim.opt_local.conceallevel = 0
    vim.opt_local.undolevels = 100
    vim.opt_local.swapfile = false
    vim.opt_local.synmaxcol = 0

    -- Desactivar matchparen
    vim.cmd("NoMatchParen")

    -- Detach LSP clients del buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      buffer = ev.buf,
      callback = function(args)
        vim.schedule(function()
          vim.lsp.buf_detach_client(ev.buf, args.data.client_id)
        end)
      end,
    })

    vim.notify("⚡ Archivo grande detectado: features desactivadas", vim.log.levels.WARN)
  end,
})

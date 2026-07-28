vim.pack.add({
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-lualine/lualine.nvim'
})

local options = function()
  local buffers = require("editor.buffers")
  local icons = {
    diagnostics = { Error = " ", Warn = " ", Info = " ", Hint = " " },
    git = { added = "+", modified = "~", removed = "-" },
  }


  vim.o.laststatus = vim.g.lualine_laststatus

  -- local function pretty_path()
  --   local file = vim.fn.expand("%:~:.")   -- ruta relativa
  --   return file
  -- end

  local function buffer_position()
    local order = buffers.sync_order()
    local cur = vim.api.nvim_get_current_buf()
    local index = buffers.index_of(cur, order)
    if index then
      return index .. " : " .. #order
    end
    return "- : " .. #order
  end

  -- Mover buffer en la lista ordenada
  local function move_buffer(direction)
    local order = buffers.sync_order()
    local cur = vim.api.nvim_get_current_buf()
    local idx = buffers.index_of(cur, order)
    if not idx then return end
    local target = idx + direction
    if target < 1 or target > #order then return end
    order[idx], order[target] = order[target], order[idx]
    _G._buf_order = order
    vim.cmd("redrawstatus")
  end

  vim.keymap.set("n", "<leader>b<", function() move_buffer(-1) end, { desc = "Mover buffer a la izquierda" })
  vim.keymap.set("n", "<leader>b>", function() move_buffer(1) end, { desc = "Mover buffer a la derecha" })

  local opts = {
    options = {
      theme = "auto",
      globalstatus = vim.o.laststatus == 3,
      disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = {
        "diff",
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { "filename", padding = { left = 0, right = 1 } },
        { buffer_position, icon = "󰓩" },
        { "tabs" },
      },
      lualine_x = {
        { "searchcount" },
        { "selectioncount" },
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
        {
          "encoding",
          separator = "",
          padding = { left = 1, right = 0 }
        },
        "fileformat",
        "filesize",
        { "lsp_status", color = { gui = 'bold' } },
      },
      lualine_y = {
        "progress",
        "location",
      },
      lualine_z = {
        {
          'datetime',
          -- options: default, us, uk, iso, or your own format string ("%H:%M", etc..)
          style = 'default',
          icon = ""
        },
      },
    },
  }

  return opts
end

require('lualine').setup(options())

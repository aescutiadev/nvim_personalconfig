local lualine = {
  "nvim-lualine/lualine.nvim",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = " "
    else
      vim.o.laststatus = 0
    end
  end,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    local icons = {
      diagnostics = { Error = " ", Warn = " ", Info = " ", Hint = " " },
      git = { added = "+", modified = "~", removed = "-" },
    }


    vim.o.laststatus = vim.g.lualine_laststatus

    local function pretty_path()
      local file = vim.fn.expand("%:~:.") -- ruta relativa
      return file
    end

    -- Lista ordenada de buffers (permite reordenar)
    _G._buf_order = _G._buf_order or {}

    local function get_file_bufs()
      local bufs = {}
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
          local name = vim.api.nvim_buf_get_name(buf)
          if name ~= "" and vim.bo[buf].buflisted and vim.bo[buf].buftype == "" then
            bufs[buf] = true
          end
        end
      end
      return bufs
    end

    local function sync_buf_order()
      local file_bufs = get_file_bufs()
      -- Eliminar buffers que ya no existen
      local new_order = {}
      for _, buf in ipairs(_G._buf_order) do
        if file_bufs[buf] then
          new_order[#new_order + 1] = buf
          file_bufs[buf] = nil
        end
      end
      -- Agregar buffers nuevos al final
      for buf in pairs(file_bufs) do
        new_order[#new_order + 1] = buf
      end
      _G._buf_order = new_order
      return new_order
    end

    local function buffer_position()
      local order = sync_buf_order()
      local cur = vim.api.nvim_get_current_buf()
      for i, buf in ipairs(order) do
        if buf == cur then
          return i .. " : " .. #order
        end
      end
      return "- : " .. #order
    end

    -- Mover buffer en la lista ordenada
    local function move_buffer(direction)
      local order = sync_buf_order()
      local cur = vim.api.nvim_get_current_buf()
      local idx
      for i, buf in ipairs(order) do
        if buf == cur then idx = i; break end
      end
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
        theme = "catppuccin",
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          pretty_path,
          { buffer_position, icon = "󰓩" },
        },
        lualine_x = {
          "diff",
          {
            function()
              return require("lazy.status").updates()
            end,
            cond = require("lazy.status").has_updates,
          },
          "encoding",
          "fileformat",
          "lsp_status",
        },
        lualine_y = {
          "progress",
          "location",
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
      extensions = { "lazy" },
    }

    return opts
  end,
}

return lualine

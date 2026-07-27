vim.pack.add({
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-lualine/lualine.nvim',
})

local function git_branch_component()
  return {
    'branch',
    icon = '',
    separator = '',
    padding = { left = 1, right = 1 },
  }
end

local function git_diff_component()
  return {
    'diff',
    colored = true,
    symbols = {
      added = '+',
      modified = '~',
      removed = '-',
    },
    padding = { left = 1, right = 1 },
  }
end

local function options()
  local buffers = require("editor.buffers")

  local icons = {
    diagnostics = {
      Error = " ",
      Warn  = " ",
      Info  = " ",
      Hint  = " ",
    },
  }

  local function pretty_path()
    return vim.fn.expand("%:~:.")
  end

  local function buffer_position()
    local order = buffers.sync_order()
    local cur = vim.api.nvim_get_current_buf()
    local index = buffers.index_of(cur, order)
    if index then
      return index .. " : " .. #order
    end
    return "- : " .. #order
  end

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

  return {
    options = {
      theme = "auto",
      globalstatus = true,
      disabled_filetypes = {
        statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
      },
    },
    sections = {
      lualine_a = { "mode" },

      lualine_b = {
        git_branch_component(),
        git_diff_component(),
      },

      lualine_c = {
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
          colored = true,
          update_in_insert = false,
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        pretty_path,
        { buffer_position, icon = "󰓩" },
      },

      lualine_x = {
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
  }
end

require('lualine').setup(options())

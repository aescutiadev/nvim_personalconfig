return {
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

    -- count buffers in current tab
    local function buffer_count()
      local count = 0
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
          local name = vim.api.nvim_buf_get_name(buf)
          if name ~= "" and vim.fn.filereadable(name) == 1 then
            count = count + 1
          end
        end
      end
      return count
    end

    local opts = {
      options = {
        theme = "tokyonight",
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
          buffer_count,
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

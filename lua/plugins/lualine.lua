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
          {
            "buffers",
            show_filename_only = true,
            hide_filename_extension = false,
            show_modified_status = true,
            mode = 0, -- mostrar solo nombre pero usar path para resolver duplicados
            path = 1, -- sube un nivel de path si hay duplicados
            max_length = vim.o.columns * 2 / 3,
            use_mode_colors = true,
            symbols = {
              modified = " ●",
              alternate_file = "#",
              directory = "",
            },
            icons_enabled = false,
          },
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

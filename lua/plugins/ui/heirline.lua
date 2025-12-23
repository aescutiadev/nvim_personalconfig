local heirline = {
  "rebelot/heirline.nvim",
  -- You can optionally lazy-load heirline on UiEnter
  -- to make sure all required plugins and colorschemes are loaded before setup
  -- event = "UiEnter",
  config = function()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

    local colors = {
      bright_bg = utils.get_highlight("Folded").bg,
      bright_fg = utils.get_highlight("Folded").fg,
      red = utils.get_highlight("DiagnosticError").fg,
      dark_red = utils.get_highlight("DiffDelete").bg,
      green = utils.get_highlight("String").fg,
      blue = utils.get_highlight("Function").fg,
      gray = utils.get_highlight("NonText").fg,
      orange = utils.get_highlight("Constant").fg,
      purple = utils.get_highlight("Statement").fg,
      cyan = utils.get_highlight("Special").fg,
      diag_warn = utils.get_highlight("DiagnosticWarn").fg,
      diag_error = utils.get_highlight("DiagnosticError").fg,
      diag_hint = utils.get_highlight("DiagnosticHint").fg,
      diag_info = utils.get_highlight("DiagnosticInfo").fg,
      git_del = utils.get_highlight("diffDeleted").fg,
      git_add = utils.get_highlight("diffAdded").fg,
      git_change = utils.get_highlight("diffChanged").fg,
    }

    local Mode = {
      init = function(self)
        self.mode = vim.fn.mode(1)
      end,
      static = {
        mode_names = {
          n = "NORMAL",
          i = "INSERT",
          v = "VISUAL",
          V = "V-LINE",
          ["\22"] = "V-BLOCK",
          c = "COMMAND",
          s = "SELECT",
          R = "REPLACE",
          t = "TERMINAL",
        },
      },
      provider = function(self)
        return " " .. (self.mode_names[self.mode] or self.mode)
      end,
      hl = { bold = true, fg = colors.purple },
    }

    local FileIcon = {
      init = function(self)
        local filename = vim.api.nvim_buf_get_name(0)
        local extension = vim.fn.fnamemodify(filename, ":e")

        local icon, color = require("nvim-web-devicons")
            .get_icon_color(filename, extension, { default = true })

        self.icon = icon
        self.icon_color = color
      end,

      provider = function(self)
        return self.icon and (self.icon .. " ")
      end,

      hl = function(self)
        return { fg = self.icon_color }
      end,
    }

    local FileName = {
      provider = function()
        return vim.fn.expand("%:t") ~= "" and vim.fn.expand("%:t") or "[No Name]"
      end,
      hl = function()
        return { bold = vim.bo.modified }
      end,
    }

    local Git = {
      condition = conditions.is_git_repo,

      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,

      hl = { fg = "orange" },


      { -- git branch name
        provider = function(self)
          return " " .. self.status_dict.head
        end,
        hl = { bold = true }
      },
      -- You could handle delimiters, icons and counts similar to Diagnostics
      {
        condition = function(self)
          return self.has_changes
        end,
        provider = "("
      },
      {
        provider = function(self)
          local count = self.status_dict.added or 0
          return count > 0 and ("+" .. count)
        end,
        hl = { fg = colors.git_add },
      },
      {
        provider = function(self)
          local count = self.status_dict.removed or 0
          return count > 0 and ("-" .. count)
        end,
        hl = { fg = colors.git_del },
      },
      {
        provider = function(self)
          local count = self.status_dict.changed or 0
          return count > 0 and ("~" .. count)
        end,
        hl = { fg = colors.git_change },
      },
      {
        condition = function(self)
          return self.has_changes
        end,
        provider = ")",
      },
    }

    local Ruler = {
      provider = "%7(%l/%3L%):%2c %P",
    }


    local LSPActive = {
      condition = conditions.lsp_attached,
      update = { 'LspAttach', 'LspDetach' },
      provider = function()
        local names = {}
        for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          table.insert(names, server.name)
        end
        return " [" .. table.concat(names, " ") .. "]"
      end,
      hl = { fg = "green", bold = true },
    }

    local FileType = {
      provider = function()
        return string.upper(vim.bo.filetype)
      end,
      hl = { fg = utils.get_highlight("Type").fg, bold = true },
    }

    local FileEncoding = {
      provider = function()
        local enc = vim.bo.fenc ~= "" and vim.bo.fenc or vim.o.enc
        return " " .. enc:upper()
      end,
    }

    local FileFormat = {
      provider = function()
        return " " .. vim.bo.fileformat:upper()
      end,
    }

    local Diagnostics = {
      condition  = conditions.has_diagnostics,
      -- Fetching custom diagnostic icons
      error_icon = " ",
      warn_icon  = " ",
      info_icon  = " ",
      hint_icon  = "󰌵",

      static     = {
        error_icon = " ",
        warn_icon  = " ",
        info_icon  = " ",
        hint_icon  = "󰌵",
      },

      init       = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      end,

      update     = { "DiagnosticChanged", "BufEnter" },

      {
        provider = "![",
      },
      {
        provider = function(self)
          -- 0 is just another output, we can decide to print it or not!
          return self.errors > 0 and (self.error_icon .. self.errors .. " ")
        end,
        hl = { fg = colors.diag_error }
      },
      {
        provider = function(self)
          return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
        end,
        hl = { fg = colors.diag_warn }
      },
      {
        provider = function(self)
          return self.info > 0 and (self.info_icon .. self.info .. " ")
        end,
        hl = { fg = colors.diag_info }
      },
      {
        provider = function(self)
          return self.hints > 0 and (self.hint_icon .. self.hints)
        end,
        hl = { fg = colors.diag_hint }
      },
      {
        provider = "]",
      },
    }

    local statusLine = {
      Mode,
      { provider = " " },
      Git,
      { provider = " " },
      FileIcon,
      FileName,
      { provider = " " },
      Diagnostics,
      { provider = "%=" },
      LSPActive,
      { provider = " " },
      FileType,
      FileEncoding,
      FileFormat,
      { provider = " " },
      Ruler,
    }

    require("heirline").setup({
      statusline = statusLine,
      colors = colors,
    })
  end
}

return heirline

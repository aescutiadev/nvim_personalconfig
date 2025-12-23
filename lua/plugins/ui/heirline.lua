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
          n       = "NORMAL",
          i       = "INSERT",
          v       = "VISUAL",
          V       = "V-LINE",
          ["\22"] = "V-BLOCK",
          c       = "COMMAND",
          s       = "SELECT",
          R       = "REPLACE",
          t       = "TERMINAL",
        },
        mode_colors = {
          n       = colors.blue,
          i       = colors.green,
          v       = colors.purple,
          V       = colors.purple,
          ["\22"] = colors.purple,
          c       = colors.orange,
          s       = colors.cyan,
          R       = colors.red,
          t       = colors.cyan,
        },
      },

      provider = function(self)
        return " " .. (self.mode_names[self.mode] or self.mode)
      end,

      hl = function(self)
        return {
          fg = self.mode_colors[self.mode] or colors.gray,
          bold = true,
        }
      end,
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
        local filename = vim.fn.expand("%:~:.")
        return filename ~= "" and filename or "[No Name]"
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
      hint_icon  = "󰌵 ",

      static     = {
        error_icon = " ",
        warn_icon  = " ",
        info_icon  = " ",
        hint_icon  = "󰌵 ",
      },

      init       = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      end,

      update     = { "DiagnosticChanged", "BufEnter" },

      { provider = "!(" },
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
      { provider = ")" },
    }

    -- BUFFER LINE CONFIGURATION

    -- we redefine the filename component, as we probably only want the tail and not the relative path
    local TablineFileName = {
      provider = function(self)
        -- self.filename will be defined later, just keep looking at the example!
        local filename = self.filename
        filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
        return filename
      end,
      hl = function(self)
        return { bold = self.is_active or self.is_visible, italic = true }
      end,
    }

    local TablineFileFlags = {
      {
        condition = function(self)
          return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
        end,
        provider = "[+]",
        hl = { fg = "green" },
      },
      {
        condition = function(self)
          return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
              or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
        end,
        provider = function(self)
          if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
            return "  "
          else
            return ""
          end
        end,
        hl = { fg = "orange" },
      },
    }

    -- Here the filename block finally comes together
    local TablineFileNameBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(self.bufnr)
      end,
      hl = function(self)
        if self.is_active then
          return "TabLineSel"
          -- why not?
          -- elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
          --     return { fg = "gray" }
        else
          return "TabLine"
        end
      end,
      on_click = {
        callback = function(_, minwid, _, button)
          if (button == "m") then -- close on mouse middle click
            vim.schedule(function()
              vim.api.nvim_buf_delete(minwid, { force = false })
            end)
          else
            vim.api.nvim_win_set_buf(0, minwid)
          end
        end,
        minwid = function(self)
          return self.bufnr
        end,
        name = "heirline_tabline_buffer_callback",
      },
      FileIcon, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
      TablineFileName,
      TablineFileFlags,
    }

    -- a nice "x" button to close the buffer
    local TablineCloseButton = {
      condition = function(self)
        return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
      end,
      { provider = " " },
      {
        provider = "",
        hl = { fg = "gray" },
        on_click = {
          callback = function(_, minwid)
            vim.schedule(function()
              vim.api.nvim_buf_delete(minwid, { force = false })
              vim.cmd.redrawtabline()
            end)
          end,
          minwid = function(self)
            return self.bufnr
          end,
          name = "heirline_tabline_close_buffer_callback",
        },
      },
    }

    local TabLineOffset = {
      condition = function(self)
        local win = vim.api.nvim_tabpage_list_wins(0)[1]
        local bufnr = vim.api.nvim_win_get_buf(win)
        self.winid = win

        local ft = vim.bo[bufnr].filetype
        local name = vim.api.nvim_buf_get_name(bufnr)

        if ft == "neo-tree" or name:match("^neo%-tree://") then
          self.title = "Neo-Tree"
          return true
        end
      end,

      provider = function(self)
        local title = self.title
        local width = vim.api.nvim_win_get_width(self.winid)
        local pad = math.floor((width - #title) / 2)
        return string.rep(" ", pad) .. title .. string.rep(" ", pad)
      end,

      hl = function(self)
        return vim.api.nvim_get_current_win() == self.winid
            and "TabLineSel"
            or "TabLine"
      end,
    }

    local TablinePicker = {
      condition = function(self)
        return self._show_picker
      end,
      init = function(self)
        local bufname = vim.api.nvim_buf_get_name(self.bufnr)
        bufname = vim.fn.fnamemodify(bufname, ":t")
        local label = bufname:sub(1, 1)
        local i = 2
        while self._picker_labels[label] do
          if i > #bufname then
            break
          end
          label = bufname:sub(i, i)
          i = i + 1
        end
        self._picker_labels[label] = self.bufnr
        self.label = label
      end,
      provider = function(self)
        return self.label
      end,
      hl = { fg = "red", bold = true },
    }

    vim.keymap.set("n", "gbp", function()
      local tabline = require("heirline").tabline
      local buflist = tabline._buflist[1]
      buflist._picker_labels = {}
      buflist._show_picker = true
      vim.cmd.redrawtabline()
      local char = vim.fn.getcharstr()
      local bufnr = buflist._picker_labels[char]
      if bufnr then
        vim.api.nvim_win_set_buf(0, bufnr)
      end
      buflist._show_picker = false
      vim.cmd.redrawtabline()
    end)

    -- The final touch!
    local TablineBufferBlock = utils.surround({ "", "" }, function(self)
      if self.is_active then
        return utils.get_highlight("TabLineSel").bg
      else
        return utils.get_highlight("TabLine").bg
      end
    end, { TablinePicker, TablineFileNameBlock, TablineCloseButton })

    -- and here we go
    local BufferLine = utils.make_buflist(
      TablineBufferBlock,
      { provider = "", hl = { fg = "gray" } }, -- left truncation, optional (defaults to "<")
      { provider = "", hl = { fg = "gray" } } -- right trunctation, also optional (defaults to ...... yep, ">")
    -- by the way, open a lot of buffers and try clicking them ;)
    )

    local Tabpage = {
      provider = function(self)
        return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
      end,
      hl = function(self)
        if not self.is_active then
          return "TabLine"
        else
          return "TabLineSel"
        end
      end,
    }

    local TabpageClose = {
      provider = "%999X  %X",
      hl = "TabLine",
    }

    local TabPages = {
      -- only show this component if there's 2 or more tabpages
      condition = function()
        return #vim.api.nvim_list_tabpages() >= 2
      end,
      { provider = "%=" },
      utils.make_tablist(Tabpage),
      TabpageClose,
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

    local tabLine = { TabLineOffset, BufferLine, TabPages }

    require("heirline").setup({
      statusline = statusLine,
      tabline = tabLine,
      colors = colors,
    })

    vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
  end
}

return heirline

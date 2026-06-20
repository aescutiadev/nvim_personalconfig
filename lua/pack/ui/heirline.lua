vim.pack.add({
  'https://github.com/rebelot/heirline.nvim',
})

local heirline = require("heirline")
local utils = require("heirline.utils")
local conditions = require("heirline.conditions")

-- ============== STATUSLINE ==============

local Space = { provider = " " }
local Align = { provider = "%=" }

local colors = {
  bg = utils.get_highlight("StatusLine").bg,
  fg = utils.get_highlight("StatusLine").fg,
  bright_bg = utils.get_highlight("Folded").bg,
  bright_fg = utils.get_highlight("Folded").fg,
  red = utils.get_highlight("DiagnosticError").fg,
  dark_red = utils.get_highlight("DiffDelete").bg,
  green = utils.get_highlight("String").fg,
  blue = utils.get_highlight("Function").fg,
  yellow = utils.get_highlight("DiagnosticWarn").fg,
  gray = utils.get_highlight("NonText").fg,
  orange = utils.get_highlight("Constant").fg,
  purple = utils.get_highlight("Statement").fg,
  cyan = utils.get_highlight("Special").fg,
  diag_warn = utils.get_highlight("DiagnosticWarn").fg,
  diag_error = utils.get_highlight("DiagnosticError").fg,
  diag_hint = utils.get_highlight("DiagnosticHint").fg,
  diag_info = utils.get_highlight("DiagnosticInfo").fg,
  git_del = utils.get_highlight("DiagnosticError").fg,
  git_add = utils.get_highlight("String").fg,
  git_change = utils.get_highlight("DiagnosticHint").fg,
}

require("heirline").load_colors(colors)

local mode_colors = {
  n = "blue",
  i = "green",
  v = "cyan",
  V = "cyan",
  ["\22"] = "cyan",
  c = "orange",
  R = "red",
  t = "green",
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
      R = "REPLACE",
      t = "TERMINAL",
    },
  },
  provider = function(self)
    return " %2(" .. (self.mode_names[self.mode] or self.mode) .. "%) "
  end,
  hl = function(self)
    local color = mode_colors[self.mode:sub(1, 1)] or "blue"
    return { fg = "bg", bg = color, bold = true }
  end,
  update = { "ModeChanged" },
}

-- Nombre de archivo relativo a la raíz del proyecto (git root)
local FileIcon = {
  init = function(self)
    local filename = vim.api.nvim_buf_get_name(0)
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return " " .. self.icon and (" " .. self.icon .. " ") or ""
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end
}

local FileName = {
  {
    provider = function()
      local root = vim.fs.root(0, ".git") or vim.fn.getcwd()
      local filename = vim.api.nvim_buf_get_name(0)
      if filename == "" then
        return "[Sin nombre]"
      end
      filename = vim.fn.fnamemodify(filename, ":p"):gsub("^" .. vim.pesc(root .. "/"), "")
      return filename
    end,
    hl = { fg = "fg" },
  },
  {
    condition = function() return vim.bo.modified end,
    provider = " ●",
    hl = { fg = "green" },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = " ",
    hl = { fg = "orange" },
  },
}

local function is_untracked()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return false
  end

  local root = vim.fs.root(0, ".git")
  if not root then
    return false
  end

  local rel = vim.fs.relpath(root, file)
  if not rel then
    return false
  end

  local result = vim.fn.systemlist({
    "git",
    "-C",
    root,
    "status",
    "--porcelain",
    "--",
    rel,
  })

  return result[1] and result[1]:match("^%?%?")
end

local Git = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict or {}

    local added = self.status_dict.added or 0
    local removed = self.status_dict.removed or 0
    local changed = self.status_dict.changed or 0

    self.has_changes = added ~= 0 or removed ~= 0 or changed ~= 0
    self.untracked = is_untracked()
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
    provider = "(",
    hl = { fg = "gray" },
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ("+" .. count)
    end,
    hl = { fg = "git_add" },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and ("-" .. count)
    end,
    hl = { fg = "git_del" },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and ("~" .. count)
    end,
    hl = { fg = "git_change" },
  },
  {
    condition = function(self)
      return self.untracked
    end,

    provider = "(+)",

    hl = { fg = "git_add" },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ")",
    hl = { fg = "gray" },
  },
}

local Diagnostics = {
  condition = conditions.has_diagnostics,
  update = { "DiagnosticChanged", "BufEnter" },
  static = {
    icons = vim.diagnostic.config().signs.text,
  },
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,
  {
    provider = function(self)
      return self.errors > 0 and (self.icons[vim.diagnostic.severity.ERROR] .. " " .. self.errors .. " ") or ""
    end,
    hl = { fg = "diag_error" },
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.icons[vim.diagnostic.severity.WARN] .. " " .. self.warnings .. " ") or ""
    end,
    hl = { fg = "diag_warn" },
  },
  {
    provider = function(self)
      return self.info > 0 and (self.icons[vim.diagnostic.severity.INFO] .. " " .. self.info .. " ") or ""
    end,
    hl = { fg = "diag_info" },
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.icons[vim.diagnostic.severity.HINT] .. " " .. self.hints .. " ") or ""
    end,
    hl = { fg = "diag_hint" },
  },
}

local Clock = {
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  provider = function()
    return " " .. os.date("%H:%M") .. " "
  end,
  hl = function(self)
    local color = mode_colors[self.mode:sub(1, 1)] or "blue"
    return { fg = "bg", bg = color, bold = true }
  end,
  update = { "ModeChanged", "User" },
}

-- ============== LSP PROGRESS + ACTIVOS ==============

local lsp_progress = {} ---@type table<integer, {token:any, msg:string, percentage:number?, done:boolean}[]>

vim.api.nvim_create_autocmd("LspProgress", {
  group = vim.api.nvim_create_augroup("heirline_lsp_progress", { clear = true }),

  callback = function(ev)
    local client_id = ev.data.client_id
    local value = ev.data.params.value

    if type(value) ~= "table" then
      return
    end

    local entries = lsp_progress[client_id] or {}
    local found = false

    for i, e in ipairs(entries) do
      if e.token == ev.data.params.token then
        entries[i] = {
          token = ev.data.params.token,
          msg = value.message or value.title or "",
          percentage = value.percentage,
          done = value.kind == "end",
        }

        found = true
        break
      end
    end

    if not found then
      table.insert(entries, {
        token = ev.data.params.token,
        msg = value.message or value.title or "",
        percentage = value.percentage,
        done = value.kind == "end",
      })
    end

    lsp_progress[client_id] = vim.tbl_filter(function(e)
      return not e.done
    end, entries)

    if #lsp_progress[client_id] == 0 then
      lsp_progress[client_id] = nil
    end

    vim.schedule(function()
      vim.cmd("redrawstatus")
    end)
  end,
})

local LspProgress = {
  condition = function()
    return next(lsp_progress) ~= nil
  end,

  update = { "LspProgress" },

  provider = function()
    local msgs = {}

    for _, entries in pairs(lsp_progress) do
      for _, e in ipairs(entries) do
        local text = e.msg

        if e.percentage then
          text = string.format("%s %d%%", text, e.percentage)
        end

        msgs[#msgs + 1] = text
      end
    end

    return "󱥸 " .. table.concat(msgs, " | ")
  end,

  hl = { fg = "cyan" },
}

local LSPActive = {
  condition = function()
    return conditions.lsp_attached()
        and next(lsp_progress) == nil
  end,

  update = { "LspAttach", "LspDetach" },

  init = function(self)
    local names = {}

    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
      names[#names + 1] = client.name
    end

    self.names = names
  end,

  provider = function(self)
    return #self.names > 0
        and (" " .. table.concat(self.names, ", "))
        or ""
  end,

  hl = { fg = "cyan" },
}

-- We're getting minimalist here!
local Ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = "%7(%l/%3L%):%2c %P",
  hl = { fg = "green" },
}

-- I take no credits for this!
local ScrollBar = {
  static = {
    sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
    -- Another variant, because the more choice the better.
    -- sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return " " .. string.rep(self.sbar[i], 2) .. " "
  end,
  hl = { fg = "green", bg = "bright_bg" },
}

local StatusLine = {
  hl = function()
    return conditions.is_active() and "StatusLine" or "StatusLineNC"
  end,
  Mode,
  Space,
  Git,
  FileIcon,
  FileName,
  Space,
  Align,
  Diagnostics,
  LspProgress,
  Space,
  LSPActive,
  Space,
  Ruler,
  Space,
  ScrollBar,
  Clock,
}

-- ============== SETUP ==============

heirline.setup({
  statusline = StatusLine,
  opts = {
    colors = colors,
  },
})

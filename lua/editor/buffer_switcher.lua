local buffers = require("editor.buffers")

local M = {}

local api = vim.api
local ns = api.nvim_create_namespace("buffer_switcher")

local defaults = {
  timeout = 3000,
  border = "rounded",
  margin_top = 1,
  margin_right = 2,
  min_width = 20,
  max_width = 42,
  prefix = "➤ ",
  inactive_prefix = "  ",
  zindex = 160,
}

local config = vim.deepcopy(defaults)

local state = {
  active = false,
  win = nil,
  buf = nil,
  source_win = nil,
  order = {},
  index = 1,
  timer_id = nil,
}

local function get_hl(name)
  local ok, hl = pcall(api.nvim_get_hl, 0, { name = name, link = false })
  return ok and hl or {}
end

local function pick(...)
  for i = 1, select("#", ...) do
    local value = select(i, ...)
    if value ~= nil then
      return value
    end
  end
end

local function setup_highlights()
  local normal = get_hl("NormalFloat")
  local border = get_hl("FloatBorder")
  local selected = get_hl("PmenuSel")
  local visual = get_hl("Visual")

  local normal_fg = pick(normal.fg, selected.fg, visual.fg)
  local normal_bg = pick(normal.bg, visual.bg, selected.bg)
  local selected_fg = pick(selected.fg, normal_fg)
  local selected_bg = pick(selected.bg, visual.bg, border.fg, normal_bg)

  api.nvim_set_hl(0, "BufferSwitcherNormal", {
    fg = normal_fg,
    bg = normal_bg,
  })

  api.nvim_set_hl(0, "BufferSwitcherBorder", {
    fg = pick(border.fg, selected_bg, normal_fg),
    bg = normal_bg,
  })

  api.nvim_set_hl(0, "BufferSwitcherCurrent", {
    fg = selected_fg,
    bg = selected_bg,
    bold = true,
  })

  api.nvim_set_hl(0, "BufferSwitcherCurrentPrefix", {
    fg = pick(border.fg, selected_fg, normal_fg),
    bg = selected_bg,
    bold = true,
  })

  api.nvim_set_hl(0, "BufferSwitcherPrefix", {
    fg = pick(border.fg, normal_fg),
    bg = normal_bg,
  })
end

local function is_float(winid)
  if not winid or not api.nvim_win_is_valid(winid) then
    return false
  end

  return api.nvim_win_get_config(winid).relative ~= ""
end

local function current_source_buf()
  if state.source_win and api.nvim_win_is_valid(state.source_win) then
    return api.nvim_win_get_buf(state.source_win)
  end

  return api.nvim_get_current_buf()
end

local function stop_timer()
  if state.timer_id then
    vim.fn.timer_stop(state.timer_id)
    state.timer_id = nil
  end
end

local function start_timer()
  stop_timer()

  state.timer_id = vim.fn.timer_start(config.timeout, function()
    vim.schedule(function()
      if state.active then
        M.close()
      end
    end)
  end)
end

local function ensure_scratch_buffer()
  if state.buf and api.nvim_buf_is_valid(state.buf) then
    return state.buf
  end

  state.buf = api.nvim_create_buf(false, true)
  vim.bo[state.buf].bufhidden = "hide"
  vim.bo[state.buf].buftype = "nofile"
  vim.bo[state.buf].buflisted = false
  vim.bo[state.buf].swapfile = false
  vim.bo[state.buf].modifiable = false
  vim.bo[state.buf].filetype = "buffer-switcher"

  vim.keymap.set("n", "<Tab>", function()
    M.next()
  end, { buffer = state.buf, silent = true, nowait = true, desc = "Siguiente buffer" })

  vim.keymap.set("n", "<S-Tab>", function()
    M.prev()
  end, { buffer = state.buf, silent = true, nowait = true, desc = "Buffer anterior" })

  -- Teclas que cierran popup
  for _, key in ipairs({ "<Esc>", "q", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" }) do
    vim.keymap.set("n", key, function()
      M.close()
    end, { buffer = state.buf, silent = true, nowait = true })
  end

  return state.buf
end

local function sync_state_order(selected_buf)
  local order = buffers.sync_order()
  if #order == 0 then
    state.order = {}
    state.index = 1
    return false
  end

  state.order = order
  state.index = buffers.index_of(selected_buf, order)
    or buffers.index_of(current_source_buf(), order)
    or math.min(state.index, #order)
    or 1

  return true
end

local function render()
  if not state.active then
    return
  end

  if #state.order == 0 then
    M.close()
    return
  end

  local bufnr = ensure_scratch_buffer()
  local lines = {}
  local width = 0

  api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  for i, buf in ipairs(state.order) do
    local prefix = i == state.index and config.prefix or config.inactive_prefix
    local line = prefix .. buffers.display_name(buf, state.order)

    lines[i] = line
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end

  vim.bo[bufnr].modifiable = true
  api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.bo[bufnr].modifiable = false

  for i, line in ipairs(lines) do
    local prefix = i == state.index and config.prefix or config.inactive_prefix
    api.nvim_buf_add_highlight(
      bufnr,
      ns,
      i == state.index and "BufferSwitcherCurrentPrefix" or "BufferSwitcherPrefix",
      i - 1,
      0,
      #prefix
    )

    if i == state.index then
      api.nvim_buf_set_extmark(bufnr, ns, i - 1, 0, {
        end_row = i,
        hl_eol = true,
        line_hl_group = "BufferSwitcherCurrent",
      })
      api.nvim_buf_add_highlight(bufnr, ns, "BufferSwitcherCurrent", i - 1, #prefix, #line)
    end
  end

  local opts = {
    relative = "editor",
    anchor = "NE",
    row = config.margin_top,
    col = vim.o.columns - config.margin_right,
    width = math.max(config.min_width, math.min(width + 1, config.max_width)),
    height = #lines,
    style = "minimal",
    border = config.border,
    focusable = true,
    noautocmd = true,
    zindex = config.zindex,
  }

  if state.win and api.nvim_win_is_valid(state.win) then
    api.nvim_win_set_config(state.win, opts)
  else
    state.win = api.nvim_open_win(bufnr, true, opts)
  end

  if api.nvim_get_current_win() ~= state.win then
    api.nvim_set_current_win(state.win)
  end

  api.nvim_win_set_cursor(state.win, { state.index, 0 })
  api.nvim_set_option_value("cursorline", true, { win = state.win })
  api.nvim_set_option_value("number", false, { win = state.win })
  api.nvim_set_option_value("relativenumber", false, { win = state.win })
  api.nvim_set_option_value("signcolumn", "no", { win = state.win })
  api.nvim_set_option_value("winhl", "Normal:BufferSwitcherNormal,FloatBorder:BufferSwitcherBorder,EndOfBuffer:BufferSwitcherNormal", { win = state.win })
end

local function switch(delta)
  if not state.active then
    return
  end

  local current_win = api.nvim_get_current_win()
  local selected_buf = state.order[state.index]
  
  if not sync_state_order(selected_buf) then
    M.close()
    return
  end

  state.index = ((state.index - 1 + delta) % #state.order) + 1

  local target = state.order[state.index]
  
  -- cambio buffer en ventana origen si sigue siendo válida
  if state.source_win and api.nvim_win_is_valid(state.source_win) then
    api.nvim_win_set_buf(state.source_win, target)
  else
    -- fallback: cambio en ventana actual
    api.nvim_set_current_buf(target)
  end

  render()
  start_timer()
end

local function open()
  local current_win = api.nvim_get_current_win()

  if state.active then
    return
  end

  if vim.bo.filetype == "neo-tree" or is_float(current_win) then
    return
  end

  state.source_win = current_win
  state.active = true

  if not sync_state_order(current_source_buf()) then
    M.close()
    return
  end

  render()
  start_timer()
end

function M.toggle()
  if state.active then
    return
  end
  open()
end

function M.next()
  switch(1)
end

function M.prev()
  switch(-1)
end

function M.close()
  stop_timer()

  if state.source_win and api.nvim_win_is_valid(state.source_win) then
    pcall(api.nvim_set_current_win, state.source_win)
  end

  if state.win and api.nvim_win_is_valid(state.win) then
    pcall(api.nvim_win_close, state.win, true)
  end

  state.active = false
  state.win = nil
  state.source_win = nil
  state.order = {}
  state.index = 1
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})
  setup_highlights()
  return M
end

return M

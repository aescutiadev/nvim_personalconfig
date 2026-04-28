local M = {}

_G._buf_order = _G._buf_order or {}

function M.is_file_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
    return false
  end

  if not vim.bo[buf].buflisted or vim.bo[buf].buftype ~= "" then
    return false
  end

  return vim.api.nvim_buf_get_name(buf) ~= ""
end

function M.list()
  local bufs = {}

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if M.is_file_buffer(buf) then
      bufs[#bufs + 1] = buf
    end
  end

  table.sort(bufs)

  return bufs
end

function M.sync_order()
  local remaining = {}
  for _, buf in ipairs(M.list()) do
    remaining[buf] = true
  end

  local order = {}
  for _, buf in ipairs(_G._buf_order) do
    if remaining[buf] then
      order[#order + 1] = buf
      remaining[buf] = nil
    end
  end

  local missing = {}
  for buf in pairs(remaining) do
    missing[#missing + 1] = buf
  end

  table.sort(missing)
  vim.list_extend(order, missing)

  _G._buf_order = order

  return order
end

function M.index_of(buf, order)
  for i, item in ipairs(order) do
    if item == buf then
      return i
    end
  end
end

function M.step(direction, current_buf)
  local order = M.sync_order()
  if #order == 0 then
    return nil, nil, order
  end

  local index = M.index_of(current_buf, order)
  if not index then
    index = direction < 0 and #order or 1
    return order[index], index, order
  end

  local next_index = ((index - 1 + direction) % #order) + 1
  return order[next_index], next_index, order
end

function M.display_name(buf, order)
  local name = vim.api.nvim_buf_get_name(buf)
  local tail = vim.fn.fnamemodify(name, ":t")

  if tail == "" then
    return "[No Name]"
  end

  -- Detectar duplicados si order se proporciona
  if order then
    local count = 0
    for _, b in ipairs(order) do
      if vim.api.nvim_buf_is_valid(b) then
        local other_name = vim.api.nvim_buf_get_name(b)
        local other_tail = vim.fn.fnamemodify(other_name, ":t")
        if other_tail == tail then
          count = count + 1
        end
      end
    end

    -- Si hay duplicados, mostrar con más contexto
    if count > 1 then
      return vim.fn.fnamemodify(name, ":~:.")
    end
  end

  return tail
end

return M

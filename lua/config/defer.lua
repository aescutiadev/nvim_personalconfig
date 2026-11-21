-- Diferido de trabajo de arranque.
--
-- `vim.pack` no tiene lazy-loading: todo plugin agregado está en runtimepath
-- desde el inicio. Lo único diferible es el `require(...).setup()`, y para eso
-- no hay que hacerlo en el camino crítico del arranque.
--
-- `vim.schedule` corre el callback en la primera vuelta del event loop, o sea
-- después de que Neovim ya dibujó. No entra en `--startuptime`.
local M = {}

local function run(name, fn)
  vim.schedule(function()
    local ok, err = pcall(fn)
    if not ok then
      vim.notify(("defer(%s): %s"):format(name, err), vim.log.levels.ERROR)
    end
  end)
end

-- Encola `fn` fuera del arranque. Nunca propaga el error: lo reporta.
---@param name string identificador para el mensaje de error
---@param fn fun()
function M.run(name, fn)
  run(name, fn)
end

-- Igual que `run`, pero sólo la primera vez que se llama a `ensure`.
---@param name string
---@param fn fun()
function M.once(name, fn)
  local done = false
  return function()
    if done then
      return
    end
    done = true
    run(name, fn)
  end
end

-- Ejecuta `fn` la primera vez que se abre un buffer de alguno de los `patterns`.
---@param patterns string|string[]
---@param name string
---@param fn fun()
function M.on_filetype(patterns, name, fn)
  local group = vim.api.nvim_create_augroup("defer_ft_" .. name, { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = patterns,
    once = true,
    callback = function()
      local ok, err = pcall(fn)
      if not ok then
        vim.notify(("defer_ft(%s): %s"):format(name, err), vim.log.levels.ERROR)
      end
    end,
  })
end

return M

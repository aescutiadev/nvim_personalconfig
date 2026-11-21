--- @module 'blink.cmp'
--- @class blink.cmp.Source
local source = {}

-- Modelo: es un modelo de razonamiento, así que necesita presupuesto de tokens
-- para los pensamientos antes de emitir `content` (con 64 devolvía content=null).
local MODEL = "deepseek-v4-flash"
local MAX_TOKENS = 400
local MIN_PREFIX = 3
local CACHE_LIMIT = 100

-- Caché simple para evitar peticiones redundantes por línea
local cache = {}
local cache_size = 0
local warned = false

-- `vim.env` usa getenv() de Vimscript y falla con E5560 en "fast event
-- context", que es donde blink resuelve las fuentes; os.getenv es seguro ahí.
local function read_env(name)
  local value = os.getenv(name)
  if value then
    return value
  end
  local ok, fallback = pcall(function()
    return vim.env[name]
  end)
  return ok and fallback or nil
end

-- IA_API_URL llega como base (https://api.nan.builders/v1); el endpoint real
-- es /chat/completions. Acepta ambas formas para no duplicar la ruta.
local function endpoint()
  local url = read_env("IA_API_URL")
  if not url or url == "" then
    return nil
  end
  url = url:gsub("/+$", "")
  if url:match("/chat/completions$") then
    return url
  end
  return url .. "/chat/completions"
end

local function empty(callback)
  callback({ items = {}, is_incomplete_backward = false, is_incomplete_forward = false })
end

local function notify_once(msg)
  if warned then
    return
  end
  warned = true
  vim.notify(msg, vim.log.levels.WARN)
end

function source.new(opts)
  local self = setmetatable({}, { __index = source })
  self.opts = opts or {}
  self._pending_task = nil
  return self
end

-- La fuente se auto-desactiva sin credenciales, en vez de responder vacío en silencio
function source:enabled()
  return read_env("IA_API_KEY") ~= nil and endpoint() ~= nil
end

-- (Opcional) Caracteres que disparan la fuente
function source:get_trigger_characters()
  return {}
end

-- Peticion a la API externa con cancelación
function source:_request(prompt, callback)
  local api_key = read_env("IA_API_KEY")
  local url = endpoint()

  if not api_key or not url then
    notify_once("IA autocomplete: faltan IA_API_KEY / IA_API_URL en el entorno")
    empty(callback)
    return function() end
  end

  local payload = vim.json.encode({
    model = MODEL,
    messages = {
      { role = "system", content = "You are a coding assistant. Complete the code snippet provided. Return ONLY the code completion, no explanations." },
      { role = "user", content = prompt },
    },
    max_tokens = MAX_TOKENS,
    temperature = 0,
  })

  local cmd = {
    "curl", "-s", "-m", "20", "-X", "POST", url,
    "-H", "Content-Type: application/json",
    "-H", "Authorization: Bearer " .. api_key,
    "-d", payload,
  }

  self._pending_task = vim.system(cmd, {}, function(ctx)
    self._pending_task = nil

    if ctx.code ~= 0 or not ctx.stdout or ctx.stdout == "" then
      empty(callback)
      return
    end

    local ok, data = pcall(vim.json.decode, ctx.stdout)
    if not ok or not data.choices or #data.choices == 0 then
      empty(callback)
      return
    end

    -- Con modelos de razonamiento `content` puede ser null (JSON null = vim.NIL),
    -- no un string: `type(...) ~= "string"` lo descarta sin romper.
    local completion = data.choices[1].message.content
    if type(completion) ~= "string" then
      empty(callback)
      return
    end

    completion = completion:gsub("^%s*", ""):gsub("%s*$", "")
    -- El modelo envuelve el código en un bloque markdown; eso no sirve como
    -- texto insertado en el buffer.
    completion = completion:gsub("^```[%w]*%s*\n?", ""):gsub("\n?```$", "")
    completion = completion:gsub("^%s*", ""):gsub("%s*$", "")
    if completion == "" then
      empty(callback)
      return
    end

    callback({
      items = {
        {
          label = completion,
          kind = require("blink.cmp.types").CompletionItemKind.Text,
          insertText = completion,
          detail = "IA Custom",
        },
      },
      is_incomplete_backward = false,
      is_incomplete_forward = false,
    })
  end)

  -- Funcion de cancelacion: mata la peticion de curl
  return function()
    if self._pending_task then
      pcall(self._pending_task.stop)
      self._pending_task = nil
    end
  end
end

function source:get_completions(ctx, callback)
  local line = vim.api.nvim_get_current_line()

  -- Evita quemar requests en líneas vacías, prefijos triviales o al escribir
  -- un espacio (el caso típico de completado de identificadores).
  if #line < MIN_PREFIX or line:match("%s$") then
    empty(callback)
    return function() end
  end

  if cache[line] then
    callback({ items = vim.deepcopy(cache[line]), is_incomplete_backward = false, is_incomplete_forward = false })
    return function() end
  end

  return self:_request(line, function(result)
    local items = result.items or {}
    if #items > 0 then
      if cache_size >= CACHE_LIMIT then
        cache = {}
        cache_size = 0
      end
      cache[line] = vim.deepcopy(items)
      cache_size = cache_size + 1
    end
    callback(result)
  end)
end

function source:resolve(item, callback)
  item = vim.deepcopy(item)
  item.documentation = {
    kind = "markdown",
    value = "**IA Custom Autocomplete**\n\nGenerado via `IA_API_URL`.",
  }
  callback(item)
end

return source

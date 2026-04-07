-- Diagnósticos del proyecto completo con herramientas de análisis estático.
-- Solo se ejecuta bajo demanda (no afecta el rendimiento general).
-- Uso: require("core.project_diagnostics").run()

local M = {}

--- Checkers disponibles — se activan cuando existen los archivos marcadores.
--- Para agregar un nuevo lenguaje, solo agrega una entrada a esta tabla.
---@type { name: string, markers: string[], cmd: string[], efm: string }[]
M.checkers = {
  {
    name = "TypeScript",
    markers = { "tsconfig.json" },
    cmd = { "npx", "tsc", "--noEmit", "--pretty", "false" },
    efm = table.concat({
      "%f(%l\\,%c): %trror TS%n: %m",
      "%f(%l\\,%c): %tarning TS%n: %m",
      "%-G%.%#",
    }, ","),
  },
  {
    name = "Astro",
    markers = { "astro.config.mjs", "astro.config.ts", "astro.config.mts" },
    cmd = { "npx", "astro", "check" },
    efm = table.concat({
      "%f:%l:%c %m",
      "%-G%.%#",
    }, ","),
  },
  {
    name = "PHP (PHPStan)",
    markers = { "phpstan.neon", "phpstan.neon.dist", "phpstan.dist.neon" },
    cmd = { "./vendor/bin/phpstan", "analyse", "--error-format=raw", "--no-progress" },
    efm = table.concat({
      "%f:%l:%m",
      "%-G%.%#",
    }, ","),
  },
  {
    name = "Rust",
    markers = { "Cargo.toml" },
    cmd = { "cargo", "check", "--message-format=short", "--color=never" },
    efm = table.concat({
      "%f:%l:%c: %trror%m",
      "%f:%l:%c: %tarning%m",
      "%-G%.%#",
    }, ","),
  },
  {
    name = "Go",
    markers = { "go.mod" },
    cmd = { "go", "vet", "./..." },
    efm = table.concat({
      "%f:%l:%c: %m",
      "%f:%l: %m",
      "%-G%.%#",
    }, ","),
  },
  {
    name = "Python (Ruff)",
    markers = { "ruff.toml", ".ruff.toml", "pyproject.toml" },
    cmd = { "ruff", "check", ".", "--output-format=concise" },
    efm = table.concat({
      "%f:%l:%c: %m",
      "%-G%.%#",
    }, ","),
  },
}

--- Verificar si el ejecutable del checker está disponible
---@param cmd string[]
---@return boolean
local function is_available(cmd)
  local bin = cmd[1]
  if bin == "npx" then
    return vim.fn.executable("npx") == 1
  end
  -- Rutas relativas (e.g., ./vendor/bin/phpstan)
  if bin:find("/") then
    local clean = bin:gsub("^%./", "")
    return vim.uv.fs_stat(vim.fn.getcwd() .. "/" .. clean) ~= nil
  end
  return vim.fn.executable(bin) == 1
end

--- Detectar checkers aplicables al proyecto actual
---@return table[]
function M.detect()
  local cwd = vim.fn.getcwd()
  local found = {}
  for _, checker in ipairs(M.checkers) do
    for _, marker in ipairs(checker.markers) do
      if vim.uv.fs_stat(cwd .. "/" .. marker) then
        table.insert(found, checker)
        break
      end
    end
  end
  return found
end

--- Ejecutar un checker y mostrar resultados en Snacks/quickfix
---@param checker table
function M.execute(checker)
  if not is_available(checker.cmd) then
    vim.notify(checker.cmd[1] .. " no encontrado — instálalo para usar " .. checker.name, vim.log.levels.ERROR)
    return
  end

  vim.notify("⏳ " .. checker.name .. ": analizando proyecto…", vim.log.levels.INFO)

  vim.system(checker.cmd, {
    text = true,
    cwd = vim.fn.getcwd(),
    env = { NO_COLOR = "1" },
    timeout = 120000,
  }, vim.schedule_wrap(function(result)
    local stdout = result.stdout or ""
    local stderr = result.stderr or ""
    local output = stdout .. "\n" .. stderr
    local lines = vim.split(output, "\n", { trimempty = true })

    if #lines == 0 then
      vim.notify("✓ " .. checker.name .. ": sin diagnósticos", vim.log.levels.INFO)
      return
    end

    -- Parsear con errorformat y enviar al quickfix
    vim.fn.setqflist({}, " ", {
      title = checker.name,
      lines = lines,
      efm = checker.efm,
    })

    -- Contar solo entradas válidas (archivos reales, no líneas de resumen)
    local qf = vim.fn.getqflist()
    local valid = vim.tbl_filter(function(e) return e.valid == 1 end, qf)

    if #valid == 0 then
      vim.notify("✓ " .. checker.name .. ": sin diagnósticos", vim.log.levels.INFO)
      return
    end

    vim.notify(checker.name .. ": " .. #valid .. " diagnóstico(s)", vim.log.levels.WARN)

    -- Mostrar con Snacks picker si disponible, sino quickfix nativo
    local ok, Snacks = pcall(require, "snacks")
    if ok and Snacks.picker then
      Snacks.picker.qflist({ title = checker.name .. " — Diagnósticos" })
    else
      vim.cmd("copen")
    end
  end))
end

--- Punto de entrada: detectar proyecto y ejecutar diagnósticos
function M.run()
  local checkers = M.detect()

  if #checkers == 0 then
    vim.notify("No se detectó proyecto soportado en " .. vim.fn.getcwd(), vim.log.levels.WARN)
    return
  end

  if #checkers == 1 then
    M.execute(checkers[1])
    return
  end

  -- Múltiples checkers detectados — dejar elegir
  vim.ui.select(checkers, {
    prompt = "Diagnósticos del proyecto:",
    format_item = function(c) return c.name end,
  }, function(choice)
    if choice then
      M.execute(choice)
    end
  end)
end

return M

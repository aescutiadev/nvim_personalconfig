-- Lista de globals reconocidas
globals = {
  "vim", -- Neovim API
  "describe",
  "it",
  "before_each",
  "after_each",
  "setup",
  "teardown",
  "pending",
  "async", -- Busted
  "Snacks", -- Nuestro plugin Snacks
  "snacks",
  "Blink",
  "blink",
}

-- Ignorar ciertos errores
ignore = {
  -- Ignorar advertencias de variables no usadas en ciertos archivos si quieres
  "011", -- unused variable
}

-- Opciones de estilo de código
std = "lua53" -- Estándar de Lua

-- Máximo número de líneas por archivo
max_line_length = 120

-- Directorios a ignorar
exclude_files = {
  "data/**/*.lua",
  "node_modules/**/*.lua",
}


local opt = vim.opt

vim.o.statuscolumn = ""

-- 📄 Apariencia y navegación
opt.number = true         -- Números de línea
opt.relativenumber = true -- Números relativos
opt.signcolumn = "yes"    -- Columna de signos siempre visible
opt.cursorline = true     -- Resaltar la línea actual
opt.scrolloff = 8         -- Margen vertical
opt.sidescrolloff = 8     -- Margen horizontal
opt.wrap = true           -- Ajusta líneas largas visualmente
opt.linebreak = true      -- Rompe líneas por palabras
opt.termguicolors = true  -- Colores verdaderos
opt.winborder = "rounded" -- Set the default border for all floating windows

-- 🆕 Neovim 0.12: Popup menu improvements
vim.o.pumborder = "rounded" -- Borde del popup de completado (nuevo en 0.12)
vim.o.pummaxwidth = 40      -- Ancho máximo del popup de completado (nuevo en 0.12)

-- ⌨️ Edición y sangría
opt.tabstop = 2        -- Espacios por tabulador
opt.shiftwidth = 2     -- Espacios para sangría
opt.expandtab = true   -- Usar espacios en vez de tabs
opt.smartindent = true -- Sangría inteligente
opt.shiftround = true  -- Redondear sangría al múltiplo más cercano

-- 🔍 Búsqueda
opt.ignorecase = true                                  -- Ignorar mayúsculas/minúsculas
opt.smartcase = true                                   -- ... salvo que uses mayúsculas
opt.infercase = true                                   -- Ajustar capitalización en completado
opt.incsearch = true                                   -- Buscar mientras escribes
opt.shortmess:append("s")                              -- Evita spam de search
opt.hlsearch = true                                    -- Resaltar coincidencias
opt.showmatch = true                                   -- Resaltar paréntesis/corchetes
opt.grepprg = "rg --vimgrep --no-heading --smart-case" -- Enhanced ripgrep configuration
opt.grepformat = "%f:%l:%c:%m"                         -- Format string for ripgrep output parsing

-- 🖱️ Interacción y usabilidad
opt.mouse = "a"                                     -- Habilitar ratón
opt.showcmd = true                                  -- Ver comandos mientras se tipea
-- opt.clipboard = "unnamedplus"    -- Copiar/pegar al portapapeles del sistema
opt.confirm = true                                  -- Confirmar al cerrar buffers con cambios
opt.timeoutlen = 400                                -- Popup de which-key más rápido
opt.completeopt = { "menu", "menuone", "noselect", "nearest" } -- Autocompletado amigable (nearest: orden por proximidad, 0.12)
-- opt.timeoutlen = 300             -- Delay corto para combinaciones de teclas

-- 📂 Ventanas y splits
opt.splitright = true      -- Splits verticales a la derecha
opt.splitkeep = "screen"   -- Evita saltos raros de scroll al dividir ventanas.
opt.splitbelow = true      -- Splits horizontales abajo
opt.jumpoptions = "view"   -- Restaurar vista exacta al saltar (Ctrl-o, gd, etc.)
opt.winminwidth = 5      -- Ancho mínimo de ventana
opt.colorcolumn = "120"  -- Guía de longitud máxima
opt.smoothscroll = true

-- 💾 Archivos y rendimiento
opt.undofile = true        -- Historial de deshacer persistente
opt.history = 10000        -- Mayor buffer de comandos/search
opt.autowrite = true       -- Guardar automáticamente en ciertos comandos
opt.updatetime = 200       -- Eventos más rápidos (CursorHold, diagnósticos)
opt.backup = false         -- No crear archivos de respaldo
opt.writebackup = false    -- No crear respaldo temporal al escribir
opt.swapfile = false       -- Desactivar archivos swap (con undofile es suficiente)
opt.undolevels = 10000     -- Más niveles de deshacer
opt.hidden = true          -- Permitir buffers ocultos con cambios
opt.autoread = true        -- Recargar archivos modificados externamente
opt.encoding = "utf-8"     -- Codificación por defecto
opt.fileencoding = "utf-8" -- Codificación de archivos

-- 🛠 Misceláneo
opt.virtualedit = "block"          -- Mover cursor donde no hay texto (bloque visual)
opt.wildmode = "longest:full,full" -- Autocompletado en línea de comandos
opt.pumheight = 15                 -- Máximo de elementos en menú emergente

opt.wrapscan = true

opt.wildmenu = true

-- 🎨 Visual y UX
opt.conceallevel = 2     -- Ocultar elementos de sintaxis (útil para markdown)
opt.concealcursor = "nc" -- Cuando ocultar (normal y command mode)
opt.list = true          -- Mostrar caracteres invisibles
opt.breakindent = true
opt.listchars = {
  tab = "→ ", -- Show tabs as →
  trail = "•", -- Trailing spaces as •
  extends = "▸", -- Line continues to the right
  precedes = "◂", -- Line continues to the left
  nbsp = "␣", -- Non-breaking spaces
}
opt.fillchars = { -- Characters for UI elements
  fold = " ",
  eob = " ", -- End of buffer
  diff = "╱", -- Deleted lines in diff mode
  msgsep = "‾",
  foldopen = "▾",
  foldsep = "│",
  foldclose = "▸",
}

-- 🚀 Rendimiento
-- opt.lazyredraw = false -- No lazy redraw (mejor para plugins modernos)
-- opt.ttyfast = true -- Terminal rápido
opt.synmaxcol = 300 -- Límite de sintaxis por línea (mejor rendimiento)
opt.exrc = true     -- Cargar .nvim.lua local por proyecto (con confirmación)
opt.undoreload = 10000

-- 📝 Edición avanzada
opt.formatoptions:remove("c") -- No auto-wrap comentarios
opt.formatoptions:remove("r") -- No continuar comentarios con Enter
opt.formatoptions:remove("o") -- No continuar comentarios con o/O
opt.formatoptions:append("j") -- Unir líneas inteligentemente
opt.iskeyword:append("-")     -- Tratar - como parte de palabras

-- Preview substitutions
vim.opt.inccommand = "split"

-- 🖼️ Interfaz
opt.showmode = false                                  -- Lualine ya muestra el modo
opt.cmdheight = 1                                     -- Altura de línea de comandos (0 = auto)
opt.laststatus = 3                                    -- Statusline global (una sola barra)
opt.showtabline = 1                                   -- No mostrar tabline por defecto
opt.winbar = "%=%m %{fnamemodify(expand('%'), ':.')}" -- Winbar simple con nombre de archivo

-- 🎯 Fold (plegado de código)
opt.foldmethod = "expr"                          -- Usar expresiones para folding
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Treesitter folding
opt.foldlevelstart = 99                          -- Empezar con todo desplegado
opt.foldnestmax = 100                            -- Máximo anidamiento de folds
opt.foldenable = true

-- 🌐 Sesiones
opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
}

-- 🔧 Spell checking (opcional)
-- opt.spell = true
-- opt.spelllang = { "en", "es" }

-- 🎪 Diff mode
opt.diffopt:append("iwhite")             -- Ignorar whitespace en diffs
opt.diffopt:append("algorithm:patience") -- Mejor algoritmo de diff
-- indent-heuristic y inline:char son defaults en Neovim 0.12
opt.diffopt:append("linematch:60")    -- Mejor matching intra-línea (Neovim 0.9+)

-- 💡 Diagnósticos y LSP
opt.shortmess:append("c") -- No mostrar mensajes de completado
opt.shortmess:append("I") -- No mostrar intro message

-- 🎨 Cursor shapes (opcional)
opt.guicursor = {
  "n-v-c:block",                                 -- Normal, visual, command: block
  "i-ci-ve:ver25",                               -- Insert, command insert, visual exclusive: vertical bar
  "r-cr:hor20",                                  -- Replace, command replace: horizontal bar
  "o:hor50",                                     -- Operator pending: horizontal bar
  "a:blinkwait700-blinkoff400-blinkon250",       -- All modes: blink settings
  "sm:block-blinkwait175-blinkoff150-blinkon175", -- Showmatch: block with blink
}

-- 🎛️ Wildmenu (mejor autocompletado en command line)
opt.wildoptions = "pum" -- Usar popup menu para <LeftMouse>ildmenu
opt.pumblend = 10       -- Transparencia del popup menu
opt.winblend = 10       -- Transparencia de ventanas flotantes

-- 🔌 Provider Configuration
-- Disable unused providers to avoid warnings
vim.g.loaded_perl_provider = 0 -- Disable Perl provider
vim.g.loaded_ruby_provider = 0 -- Disable Ruby provider

-- Python provider - will be configured after installing python neovim package
-- vim.g.loaded_python3_provider = 0  -- Uncomment to disable if not using Python features

-- Node.js provider - will be configured after installing neovim npm package
-- vim.g.loaded_node_provider = 0     -- Uncomment to disable if not using Node.js features

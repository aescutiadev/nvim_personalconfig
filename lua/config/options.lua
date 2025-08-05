local opt = vim.opt

-- 📄 Apariencia y navegación
opt.number = true -- Números de línea
opt.relativenumber = true -- Números relativos
opt.signcolumn = "yes" -- Columna de signos siempre visible
opt.cursorline = true -- Resaltar la línea actual
opt.scrolloff = 8 -- Margen vertical
opt.sidescrolloff = 8 -- Margen horizontal
opt.wrap = true -- Ajusta líneas largas visualmente
opt.linebreak = true -- Rompe líneas por palabras
opt.termguicolors = true -- Colores verdaderos

-- ⌨️ Edición y sangría
opt.tabstop = 2 -- Espacios por tabulador
opt.shiftwidth = 2 -- Espacios para sangría
opt.expandtab = true -- Usar espacios en vez de tabs
opt.smartindent = true -- Sangría inteligente
opt.shiftround = true -- Redondear sangría al múltiplo más cercano

-- 🔍 Búsqueda
opt.ignorecase = true -- Ignorar mayúsculas/minúsculas
opt.smartcase = true -- ... salvo que uses mayúsculas
opt.incsearch = true -- Buscar mientras escribes
opt.hlsearch = true -- Resaltar coincidencias
opt.showmatch = true -- Resaltar paréntesis/corchetes

-- 🖱️ Interacción y usabilidad
opt.mouse = "a" -- Habilitar ratón
-- opt.clipboard = "unnamedplus"    -- Copiar/pegar al portapapeles del sistema
opt.confirm = true -- Confirmar al cerrar buffers con cambios
opt.completeopt = { "menu", "menuone", "noselect" } -- Autocompletado amigable
-- opt.timeoutlen = 300             -- Delay corto para combinaciones de teclas

-- 📂 Ventanas y splits
opt.splitright = true -- Splits verticales a la derecha
opt.splitbelow = true -- Splits horizontales abajo
opt.winminwidth = 5 -- Ancho mínimo de ventana

-- 💾 Archivos y rendimiento
opt.undofile = true -- Historial de deshacer persistente
opt.autowrite = true -- Guardar automáticamente en ciertos comandos
opt.updatetime = 200 -- Eventos más rápidos (CursorHold, diagnósticos)
opt.backup = false -- No crear archivos de respaldo
opt.writebackup = false -- No crear respaldo temporal al escribir
opt.swapfile = false -- Desactivar archivos swap (con undofile es suficiente)
opt.undolevels = 10000 -- Más niveles de deshacer
opt.hidden = true -- Permitir buffers ocultos con cambios

-- 🛠 Misceláneo
opt.virtualedit = "block" -- Mover cursor donde no hay texto (bloque visual)
opt.wildmode = "longest:full,full" -- Autocompletado en línea de comandos
opt.pumheight = 10 -- Máximo de elementos en menú emergente

-- 🎨 Visual y UX
opt.conceallevel = 2 -- Ocultar elementos de sintaxis (útil para markdown)
opt.concealcursor = "nc" -- Cuando ocultar (normal y command mode)
opt.list = true -- Mostrar caracteres invisibles
opt.listchars = {
  tab = "→ ", -- Mostrar tabs como →
  trail = "•", -- Espacios al final como •
  extends = "▸", -- Línea continúa a la derecha
  precedes = "◂", -- Línea continúa a la izquierda
  nbsp = "␣", -- Espacios no separables
}
opt.fillchars = {
  eob = " ", -- Caracteres al final del buffer (limpio)
  fold = " ", -- Caracteres de folding
  foldopen = "▾", -- Fold abierto
  foldsep = " ", -- Separador de fold
  foldclose = "▸", -- Fold cerrado
}

-- 🚀 Rendimiento
opt.lazyredraw = false -- No lazy redraw (mejor para plugins modernos)
opt.ttyfast = true -- Terminal rápido
opt.synmaxcol = 300 -- Límite de sintaxis por línea (mejor rendimiento)

-- 🔍 Búsqueda mejorada
opt.grepprg = "rg --vimgrep" -- Usar ripgrep si está disponible
opt.grepformat = "%f:%l:%c:%m" -- Formato para ripgrep

-- 📝 Edición avanzada
opt.formatoptions:remove("c") -- No auto-wrap comentarios
opt.formatoptions:remove("r") -- No continuar comentarios con Enter
opt.formatoptions:remove("o") -- No continuar comentarios con o/O
opt.formatoptions:append("j") -- Unir líneas inteligentemente
opt.iskeyword:append("-") -- Tratar - como parte de palabras

-- 🖼️ Interfaz
opt.cmdheight = 0 -- Altura de línea de comandos (0 = auto)
opt.laststatus = 3 -- Statusline global (una sola barra)
opt.showtabline = 0 -- No mostrar tabline por defecto
opt.winbar = "%=%m %f" -- Winbar simple con nombre de archivo

-- 🎯 Fold (plegado de código)
opt.foldmethod = "expr" -- Usar expresiones para folding
opt.foldexpr = "nvim_treesitter#foldexpr()" -- Treesitter folding
opt.foldlevelstart = 99 -- Empezar con todo desplegado
opt.foldnestmax = 10 -- Máximo anidamiento de folds

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
opt.diffopt:append("iwhite") -- Ignorar whitespace en diffs
opt.diffopt:append("algorithm:patience") -- Mejor algoritmo de diff
opt.diffopt:append("indent-heuristic")

-- 💡 Diagnósticos y LSP
opt.shortmess:append("c") -- No mostrar mensajes de completado
opt.shortmess:append("I") -- No mostrar intro message

-- 🎨 Cursor shapes (opcional)
opt.guicursor = {
  "n-v-c:block", -- Normal, visual, command: block
  "i-ci-ve:ver25", -- Insert, command insert, visual exclusive: vertical bar
  "r-cr:hor20", -- Replace, command replace: horizontal bar
  "o:hor50", -- Operator pending: horizontal bar
  "a:blinkwait700-blinkoff400-blinkon250", -- All modes: blink settings
  "sm:block-blinkwait175-blinkoff150-blinkon175", -- Showmatch: block with blink
}

-- 🎛️ Wildmenu (mejor autocompletado en command line)
opt.wildoptions = "pum" -- Usar popup menu para wildmenu
opt.pumblend = 10 -- Transparencia del popup menu

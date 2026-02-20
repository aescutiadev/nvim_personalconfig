# Guía — Agregar soporte de lenguajes Lua (lua_ls) y TypeScript (vtsls)

## Objetivo

Configurar soporte moderno de LSP y Treesitter para Lua y TypeScript
usando Mason + APIs nativas de Neovim, con carga por filetype y sin
configuración global innecesaria.

---

## PASO 1 — Instalar herramientas con Mason

1. Abre Neovim.

2. Ejecuta:

   :Mason

3. Instala los siguientes paquetes:

   * lua-language-server
   * vtsls

Opcional:

* stylua (formatter para Lua)

---

## PASO 2 — Estructura de carpetas

Asegúrate de tener esta organización:

lua/
├── lsp/
│    ├── init.lua
│    ├── lua.lua
│    └── typescript.lua
│
└── editor/
└── treesitter.lua

Esto separa:

* bootstrap LSP
* configuración por lenguaje
* Treesitter

---

## PASO 3 — Bootstrap LSP (lsp/init.lua)

Responsabilidad:

* Detectar si Mason tiene instalado un servidor
* Activarlo dinámicamente

Lógica:

* verificar lua-language-server → habilitar lua_ls
* verificar vtsls → habilitar vtsls

No debe contener configuraciones específicas del lenguaje.

---

## PASO 4 — Configuración Lua LSP (lsp/lua.lua)

Responsabilidad:

* Ajustar Lua para Neovim
* Evitar falsos diagnósticos
* Mejorar autocompletado

Configurar:

* runtime LuaJIT
* diagnostics globals = vim
* workspace runtime files
* telemetry desactivado
* snippets Replace

Activación:

* filetype = lua

---

## PASO 5 — Configuración TypeScript LSP (lsp/typescript.lua)

Responsabilidad:

* Navegación moderna
* Refactors
* Diagnósticos
* Autocompletado

Configurar:

* filetypes: typescript, javascript, tsx, jsx
* workspace support
* inlay hints (opcional)

Activación automática al abrir archivos JS/TS.

---

## PASO 6 — Treesitter nativo (editor/treesitter.lua)

Responsabilidad:

* Iniciar parser por buffer
* Highlight moderno
* Folding Treesitter

Lógica:

Al detectar filetype:

* lua → iniciar parser
* typescript → iniciar parser
* tsx → iniciar parser

Acciones:

* vim.treesitter.start(buffer)
* foldmethod = expr
* foldexpr = Treesitter API

Requiere parsers instalados.

---

## PASO 7 — Folding moderno (options.lua)

Configurar:

foldmethod = expr
foldexpr = Treesitter API

Esto aplica automáticamente a Lua y TypeScript.

---

## PASO 8 — Verificación

Abrir:

archivo.lua
archivo.ts

Comprobar:

:LspInfo
→ servidor activo

Ver Treesitter:

:lua print(vim.treesitter.highlighter.active ~= nil)

---

## Resultado esperado

Lua:

✔ autocompletado
✔ diagnósticos
✔ navegación
✔ folding

TypeScript:

✔ autocompletado
✔ refactor
✔ navegación
✔ folding

Todo cargado por filetype, sin sobrecarga global.

Fin.


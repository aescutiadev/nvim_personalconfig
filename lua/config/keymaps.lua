-- Función auxiliar
local keymap = vim.keymap

-- Cambiar la tecla líder (asegúrate de que esto esté también en init.lua antes de cargar plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- 🖋️ Modo Insertar
keymap.set("i", "jk", "<ESC>", { desc = "Salir a modo normal" })

-- Clear search highlights (cambio para evitar conflicto con <leader>n)
keymap.set("n", "<leader>nc", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Quitar resaltado con ESC en modo normal
keymap.set("n", "<Esc>", ":nohlsearch<CR><Esc>", { desc = "Quitar resaltado de búsqueda", silent = true })

-- 💾 Guardar
keymap.set("n", "<leader>w", "<CMD>w<CR>", { desc = "Guardar archivo" })
keymap.set("n", "<leader>W", "<CMD>wa<CR>", { desc = "Guardar todos los buffers" })

-- ❌ Cerrar
keymap.set("n", "<leader>q", "<CMD>q<CR>", { desc = "Cerrar ventana" })
keymap.set("n", "<leader>Q", "<CMD>qa<CR>", { desc = "Cerrar Neovim" })

-- 🪟 Ventanas
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Dividir ventana verticalmente" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Dividir ventana horizontalmente" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Igualar tamaño de ventanas" })
keymap.set("n", "<leader>sx", "<CMD>close<CR>", { desc = "Cerrar ventana actual" })

-- Navegación entre ventanas
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Ir a ventana izquierda" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Ir a ventana abajo" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Ir a ventana arriba" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Ir a ventana derecha" })

-- 📋 Copiar y pegar
keymap.set("n", "<leader>Y", '"+Y', { desc = "Copiar línea al portapapeles del sistema" })
keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copiar al portapapeles del sistema" })
keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Pegar desde portapapeles" })

-- 🔴 Macro con confirmación
keymap.set("n", "q", function()
  local answer = vim.fn.input("Start macro recording? (y/n): ")
  if answer:lower() == "y" then
    return "q" -- deja que Neovim capture el registro después
  else
    return ""  -- no hace nada
  end
end, { desc = "Confirmar antes de grabar macro", expr = true })

-- Formateo automático
-- Asignar <leader>cf para formatear el archivo actual
vim.keymap.set("n", "<leader>cf", function()
  if vim.bo.filetype == "lua" then
    vim.lsp.buf.format({ async = true })
  else
    print("No LSP client attached or not a Lua file")
  end
end, { desc = "Formatear archivo actual", expr = true })

-- Función auxiliar
local keymap = vim.keymap

-- Cambiar la tecla líder (asegúrate de que esto esté también en init.lua antes de cargar plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- 🖋️ Modo Insertar
keymap.set("i", "jk", "<ESC>", { desc = "Salir a modo normal" })

-- Clear search highlights
keymap.set("n", "<leader>nh", ":nohlsearch<CR>", { desc = "Clear search highlights" })

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
    return "" -- no hace nada
  end
end, { desc = "Confirmar antes de grabar macro", expr = true })

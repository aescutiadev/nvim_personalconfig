-- Función auxiliar
local map = vim.keymap

-- Cambiar la tecla líder (asegúrate de que esto esté también en init.lua antes de cargar plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- 🖋️ Modo Insertar
map.set("i", "jk", "<ESC>", { desc = "Salir a modo normal" })

-- Clear search highlights (cambio para evitar conflicto con <leader>n)
map.set("n", "<leader>nc", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Quitar resaltado con ESC en modo normal
map.set("n", "<Esc>", ":nohlsearch<CR><Esc>", { desc = "Quitar resaltado de búsqueda", silent = true })

-- 💾 Guardar
map.set("n", "<leader>w", "<CMD>w<CR>", { desc = "Guardar archivo" })
map.set("n", "<leader>W", "<CMD>wa<CR>", { desc = "Guardar todos los buffers" })

-- Buffers
-- Keymaps globales con excepción de neo-tree
vim.keymap.set("n", "<Tab>", function()
  if vim.bo.filetype ~= "neo-tree" then
    vim.cmd("bnext")
  end
end, { desc = "Next buffer" })

vim.keymap.set("n", "<S-Tab>", function()
  if vim.bo.filetype ~= "neo-tree" then
    vim.cmd("bprevious")
  end
end, { desc = "Previous buffer" })

map.set("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map.set("n", "<leader>X", "<cmd>bdelete!<cr>", { desc = "Force delete buffer" })
map.set("n", "<leader>bb", "<cmd>ls<cr>", { desc = "List buffers" })
map.set("n", "<leader>bp", "<cmd>b#<cr>", { desc = "Go to previos buffer" })

-- ❌ Cerrar
map.set("n", "<leader>q", "<CMD>q<CR>", { desc = "Cerrar ventana" })
map.set("n", "<leader>Q", "<CMD>qa<CR>", { desc = "Cerrar Neovim" })

-- 🪟 Ventanas
map.set("n", "<leader>sv", "<C-w>v", { desc = "Dividir ventana verticalmente" })
map.set("n", "<leader>sh", "<C-w>s", { desc = "Dividir ventana horizontalmente" })
map.set("n", "<leader>se", "<C-w>=", { desc = "Igualar tamaño de ventanas" })
map.set("n", "<leader>sx", "<CMD>close<CR>", { desc = "Cerrar ventana actual" })

-- Navegación entre ventanas
map.set("n", "<C-h>", "<C-w>h", { desc = "Ir a ventana izquierda" })
map.set("n", "<C-j>", "<C-w>j", { desc = "Ir a ventana abajo" })
map.set("n", "<C-k>", "<C-w>k", { desc = "Ir a ventana arriba" })
map.set("n", "<C-l>", "<C-w>l", { desc = "Ir a ventana derecha" })

-- 📋 Copiar y pegar
map.set("n", "<leader>Y", '"+Y', { desc = "Copiar línea al portapapeles del sistema" })
map.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copiar al portapapeles del sistema" })
map.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Pegar desde portapapeles" })

-- 🔴 Macro con confirmación
map.set("n", "q", function()
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

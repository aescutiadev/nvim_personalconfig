-- Función auxiliar
local map = vim.keymap

-- Cambiar la tecla líder (asegúrate de que esto esté también en init.lua antes de cargar plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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
-- Navegación usando lista ordenada personalizada
vim.keymap.set("n", "<Tab>", function()
  if vim.bo.filetype == "neo-tree" then return end
  local order = (_G._buf_order and #_G._buf_order > 0) and _G._buf_order or {}
  if #order == 0 then vim.cmd("bnext"); return end
  local cur = vim.api.nvim_get_current_buf()
  for i, buf in ipairs(order) do
    if buf == cur then
      local next = order[i % #order + 1]
      vim.api.nvim_set_current_buf(next)
      return
    end
  end
  vim.cmd("bnext")
end, { desc = "Next buffer" })

vim.keymap.set("n", "<S-Tab>", function()
  if vim.bo.filetype == "neo-tree" then return end
  local order = (_G._buf_order and #_G._buf_order > 0) and _G._buf_order or {}
  if #order == 0 then vim.cmd("bprevious"); return end
  local cur = vim.api.nvim_get_current_buf()
  for i, buf in ipairs(order) do
    if buf == cur then
      local prev = order[(i - 2) % #order + 1]
      vim.api.nvim_set_current_buf(prev)
      return
    end
  end
  vim.cmd("bprevious")
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

-- Redimensionar ventanas
map.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Aumentar altura" })
map.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Reducir altura" })
map.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Reducir ancho" })
map.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Aumentar ancho" })

-- 📋 Copiar y pegar
map.set("n", "<leader>Y", '"+Y', { desc = "Copiar línea al portapapeles del sistema" })
map.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copiar al portapapeles del sistema" })
map.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Pegar desde portapapeles" })

-- 🔀 Mover líneas
map.set("n", "<A-j>", "<cmd>move .+1<cr>==", { desc = "Mover línea abajo" })
map.set("n", "<A-k>", "<cmd>move .-2<cr>==", { desc = "Mover línea arriba" })
map.set("v", "<A-j>", ":move '>+1<cr>gv=gv", { desc = "Mover selección abajo", silent = true })
map.set("v", "<A-k>", ":move '<-2<cr>gv=gv", { desc = "Mover selección arriba", silent = true })

-- Mantener selección al indentar
map.set("v", "<", "<gv", { desc = "Indentar izquierda" })
map.set("v", ">", ">gv", { desc = "Indentar derecha" })

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
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Formatear con LSP" })

-- Toggle format on save (inicia desactivado)
vim.g.format_on_save = false

vim.keymap.set("n", "<leader>uf", function()
  vim.g.format_on_save = not vim.g.format_on_save
  local state = vim.g.format_on_save and "activado" or "desactivado"
  vim.notify("Format on save: " .. state)
end, { desc = "Toggle format on save" })

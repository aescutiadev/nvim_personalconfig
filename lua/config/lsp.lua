require("editor.capabilities").setup()
require("editor.handlers").setup()

-- 🩺 Diagnósticos
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = 'if_many',
    prefix = '●',
  },
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN]  = ' ',
      [vim.diagnostic.severity.INFO]  = ' ',
      [vim.diagnostic.severity.HINT]  = '󰌵 ',
    },
  },
})

-- 🚀 Servidores a activar
-- Nota: las capabilities de blink las aplica editor.capabilities#setup() sobre
-- el patrón "*"; no hay que repetirlas acá.
local servers = {
  "tsc",
  "html",
  "cssls",
  "astro",
  -- "vtsls",
  -- "gopls",
  "taplo",
  "biome",
  "lua_ls",
  "yamlls",
  "bashls",
  "jsonls",
  "ast_grep",
  "marksman",
  "dockerls",
  "tailwindcss",
  "mdx_analizer",
  "basedpyright",
  "intelephense",
  "css_variables",
  "docker_language_server",
  "docker_compose_language_service",
}

-- Un servidor habilitado sin binario no arranca: falla en silencio en cada
-- buffer de su filetype. Se habilitan sólo los que tienen ejecutable resoluble
-- y se avisa del resto una vez, al final del arranque.
local function missing_binary(name)
  local cfg = vim.lsp.config[name]
  if type(cfg) ~= "table" or type(cfg.cmd) ~= "table" then
    return nil -- cmd es una función (tsc, astro, biome...): no verificable
  end
  local exe = cfg.cmd[1]
  if not exe or vim.fn.executable(exe) == 1 then
    return nil
  end
  return exe
end

local enabled, missing = {}, {}
for _, name in ipairs(servers) do
  local exe = missing_binary(name)
  if exe then
    table.insert(missing, ("%s (%s)"):format(name, exe))
  else
    table.insert(enabled, name)
  end
end

vim.lsp.enable(enabled)

if #missing > 0 then
  vim.schedule(function()
    vim.notify(
      "LSP sin binario, deshabilitados: " .. table.concat(missing, ", ")
        .. "\nInstalá con `:MasonInstall` o quitálos de lua/config/lsp.lua.",
      vim.log.levels.WARN
    )
  end)
end

-- 💡 Inlay hints
vim.g.inlay_hints_enabled = false

vim.keymap.set("n", "<leader>uh", function()
  vim.g.inlay_hints_enabled = not vim.g.inlay_hints_enabled
  for _, client in ipairs(vim.lsp.get_clients()) do
    for bufnr in pairs(client.attached_buffers or {}) do
      vim.lsp.inlay_hint.enable(vim.g.inlay_hints_enabled, { bufnr = bufnr })
    end
  end
  vim.notify("Inlay hints: " .. (vim.g.inlay_hints_enabled and "activados" or "desactivados"))
end, { desc = "Toggle inlay hints" })

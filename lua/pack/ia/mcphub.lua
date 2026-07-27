vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/ravitemer/mcphub.nvim" },
})

-- MCPHub necesita el binario `mcp-hub` (node). Igual que arriba, lo instalamos
-- vía npm cuando el plugin cambia, ya que vim.pack no corre "build".
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local spec = ev.data.spec
    if spec and spec.name == "mcphub.nvim" and (ev.data.kind == "install" or ev.data.kind == "update") then
      vim.system({ "npm", "install", "-g", "mcp-hub@latest" }, {}, function(out)
        if out.code ~= 0 then
          vim.schedule(function()
            vim.notify("MCPHub: fallo al instalar mcp-hub\n" .. (out.stderr or ""), vim.log.levels.WARN)
          end)
        end
      end)
    end
  end,
})

require("mcphub").setup({
  -- Archivo de configuración de servidores MCP
  config = vim.fn.expand("~/.config/mcphub/servers.json"),
  port = 37373,
  shutdown_delay = 5 * 60 * 1000,
  use_bundled_binary = false, -- usamos el binario global instalado por npm arriba

  auto_approve = false,       -- pon true (o una función) si confías en tus MCP servers
  auto_toggle_mcp_servers = true,

  -- ──────────────────────────────────────────────────────────
  -- INTEGRACIÓN OFICIAL CON COPILOTCHAT
  -- Convierte tools/resources de los servidores MCP en
  -- funciones (@nombre) y recursos (#nombre) de CopilotChat
  -- ──────────────────────────────────────────────────────────
  extensions = {
    copilotchat = {
      enabled = true,
      convert_tools_to_functions = true,     -- @server__tool
      convert_resources_to_functions = true, -- @server__Resource
      add_mcp_prefix = false,                -- true -> @mcp_server__tool
    },
  },

  ui = {
    window = {
      width = 0.8,
      height = 0.8,
      align = "center",
      border = "rounded",
      relative = "editor",
    },
  },

  on_ready = function(_)
    vim.notify("MCPHub ✅", vim.log.levels.INFO)
  end,

  on_error = function(err)
    vim.notify("MCPHub error: " .. tostring(err), vim.log.levels.ERROR)
  end,

  log = {
    level = vim.log.levels.WARN,
    to_file = false,
  },
})

vim.keymap.set("n", "<leader>ah", "<cmd>MCPHub<cr>", { desc = "Abrir MCPHub UI" })

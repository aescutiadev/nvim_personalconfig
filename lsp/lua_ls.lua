-- Hereda cmd/filetypes/root_markers de nvim-lspconfig (lsp/lua_ls.lua).
--
-- El `library` apunta a raíces de plugins, y las raíces traen basura (target/,
-- tests/, doc/). Medido en este equipo: rtp completo = ~20 s de análisis antes
-- del primer request; sólo plugins con ignoreDir = ~9 s.
--
-- La API de plugins sólo se carga cuando el workspace ES tu config; en
-- cualquier otro proyecto Lua se usa sólo VIMRUNTIME (~2.5 s). Sin .luarc.json:
-- si el proyecto trae uno, manda el proyecto.
local plugin_library = {
  "snacks.nvim",
  "neo-tree.nvim",
  "blink.cmp",
  "blink.lib",
  "plenary.nvim",
  "nui.nvim",
  "CopilotChat.nvim",
  "mcphub.nvim",
  "gitsigns.nvim",
  "flash.nvim",
  "grug-far.nvim",
  "which-key.nvim",
  "tokyonight.nvim",
  "nvim-treesitter",
  "crates.nvim",
  "nvim-web-devicons",
  "oklch-color-picker.nvim",
  -- nvim-lspconfig queda afuera a propósito: son ~450 archivos (~2 s) y su API
  -- interna no se llama desde el config, sólo se lee su documentación.
}

local function is_config_workspace(root)
  if not root then
    return false
  end
  return vim.fs.normalize(root) == vim.fs.normalize(vim.fn.stdpath("config"))
end

return {
  on_init = function(client)
    local root = client.workspace_folders and client.workspace_folders[1] and client.workspace_folders[1].name

    -- Un .luarc.json/.luarc.jsonc en el proyecto desactiva TODOS estos
    -- defaults (mismo criterio que el snippet oficial de nvim-lspconfig): el
    -- proyecto declara su runtime y su library. Verificado: sin estos
    -- defaults lua_ls vuelve a Lua 5.4 y deja de completar `vim.*`, así que un
    -- proyecto que lo incluya debe declarar lo que necesita.
    if root and (vim.uv.fs_stat(root .. "/.luarc.json") or vim.uv.fs_stat(root .. "/.luarc.jsonc")) then
      return
    end

    local library = { vim.env.VIMRUNTIME }
    if is_config_workspace(root) then
      local opt = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "core", "opt")
      for _, name in ipairs(plugin_library) do
        table.insert(library, vim.fs.joinpath(opt, name))
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Neovim corre LuaJIT: el default de lua_ls es Lua 5.4
        version = "LuaJIT",
        -- cómo resuelve `require` Neovim (ver :h lua-module-load)
        path = { "lua/?.lua", "lua/?/init.lua" },
      },
      workspace = {
        library = library,
        checkThirdParty = false,
        ignoreDir = { "target", "tests", "test", "doc", "docs", "spec", "scripts" },
      },
      -- Nadie consume los code lenses (no hay vim.lsp.codelens.refresh): trabajo muerto.
      codeLens = { enable = false },
    })
  end,
  settings = {
    Lua = {
      hint = { enable = true, semicolon = "Disable" },
      diagnostics = { globals = { "vim", "Snacks" } },
      telemetry = { enable = false },
      completion = { callSnippet = "Replace" },
    },
  },
}

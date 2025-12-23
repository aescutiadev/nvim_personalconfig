local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("blink.cmp").get_lsp_capabilities()
)

vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },

  capabilities = capabilities,

  filetypes = { "lua" },

  root_markers = {
    ".emmyrc.json",
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },

  settings = {
    Lua = {
      codeLens = {
        enable = true,
      },

      runtime = {
        version = "LuaJIT",
      },

      diagnostics = {
        globals = { "vim" },
      },

      workspace = {
        checkThirdParty = false,
      },

      telemetry = {
        enabled = false,
      },
    },
  },
})

vim.lsp.enable("lua_ls")

return {}

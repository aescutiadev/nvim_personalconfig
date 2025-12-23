local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("blink.cmp").get_lsp_capabilities()
)

local lsp_name = "lua_ls"

vim.lsp.config(lsp_name, {
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
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
          continuation_indent_size = "2",

          max_line_length = "120",
          break_after_operator = true,
          break_before_brace = false,
        },
      },

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

vim.lsp.enable(lsp_name)

return {}

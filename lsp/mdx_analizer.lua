---@brief
--- https://github.com/mdx-js/mdx-analyzer
---
--- `mdx-analyzer`, a language server for MDX

local util = require 'lspconfig.util'

---@type vim.lsp.Config
return {
  cmd = { 'mdx-language-server', '--stdio' },
  filetypes = { 'mdx' },
  root_markers = { 'package.json' },
  settings = {},
  init_options = {
    typescript = {
      enabled = true,
    },
  },
  before_init = function(_, config)
    local tsdk = util.get_typescript_server_path(config.root_dir)

    if tsdk then
      config.init_options.typescript.tsdk = tsdk
    end
  end
}

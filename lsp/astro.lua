---@type vim.lsp.Config
return {
  cmd = { "astro-ls", "--stdio" },
  filetypes = { "astro" },
  root_markers = { "astro.config.mjs", "astro.config.ts", "astro.config.mts", "package.json", ".git" },
  init_options = {
    typescript = {},
  },
  before_init = function(_, config)
    if config.init_options and config.init_options.typescript and not config.init_options.typescript.tsdk then
      local tsdk = vim.fs.joinpath(config.root_dir or vim.uv.cwd(), "node_modules", "typescript", "lib")
      if vim.uv.fs_stat(tsdk) == nil then
        tsdk = nil
      end
      if tsdk then
        config.init_options.typescript.tsdk = tsdk
      end
    end
  end,
}

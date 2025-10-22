return {
  "MeanderingProgrammer/render-markdown.nvim",
  cmd = "RenderMarkdown",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  ft = function()
    local plugin = require("lazy.core.config").spec.plugins["render-markdown.nvim"]
    local opts = require("lazy.core.plugin").values(plugin, "opts", false)
    return opts.file_types or { "markdown" }
  end,
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
}

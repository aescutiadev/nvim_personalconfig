return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
      },
      win = {
        border = "rounded",
      },
      spec = {
        -- Root group
        { "", group = "Root" },
        -- Other groups
        { "b", group = "Buffer" },
        { "c", group = "Code" },
        { "f", group = "Find/Files" },
        { "g", group = "Git" },
        { "s", group = "Search" },
        { "t", group = "Toggle/Terminal" },
        { "u", group = "UI/Settings" },
        { "x", group = "Diagnostics" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },
}

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    -- Registrar grupos de teclas
    wk.add({
      mode = { "n", "v" },
      { "<leader>a", group = "copilot", icon = "󰚩" },
      { "<leader>f", group = "file", icon = "󰈙" },
      { "<leader>g", group = "git", icon = "󰊢" },
      { "<leader>s", group = "search", icon = "󰍉" },
      { "<leader>c", group = "code", icon = "󰨞" },
      { "<leader>b", group = "buffers", icon = "󰓩" },
      -- { "<leader>p", group = "plugins", icon = "󰏖" },
      { "<leader>t", group = "terminal", icon = "󰆍" },
      { "<leader>n", group = "notifications", icon = "󰎟" },
      { "<leader>h", group = "help", icon = "󰋖" },
      { "<leader>u", group = "ui", icon = "󰙵" },
      { "<leader>l", group = "lsp", icon = "󰒋" },
    })
  end,
}

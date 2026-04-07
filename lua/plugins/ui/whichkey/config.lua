local opts = {
  preset = "helix",
}

local wk = require("which-key")

wk.setup(opts)

-- Registrar grupos de teclas
wk.add({
  mode = { "n", "v" },
  { "<leader>a", group = "copilot", icon = "󰚩" },
  { "<leader>b", group = "buffers", icon = "󰓩" },
  { "<leader>c", group = "code", icon = "󰨞" },
  { "<leader>f", group = "file", icon = "󰈙" },
  { "<leader>g", group = "git", icon = "󰊢" },
  { "<leader>h", group = "git [h]unks", icon = "󰊢" },
  { "<leader>l", group = "lsp", icon = "󰒋" },
  { "<leader>L", group = "Laravel", icon = "󰘐" },
  { "<leader>n", group = "notifications", icon = "󰎟" },
  { "<leader>r", group = "replace and search", icon = "󰍉" },
  { "<leader>m", group = "multicursor", icon = "󰇀" },
  { "<leader>s", group = "search", icon = "󰍉" },
  { "<leader>t", group = "terminal", icon = "󰆍" },
  { "<leader>u", group = "ui", icon = "󰙵" },
})

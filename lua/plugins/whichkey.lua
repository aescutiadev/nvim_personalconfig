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

      { "<leader>b", group = "buffers", icon = "󰓩" },

      { "<leader>bP", "<Cmd>BufferLinePick<CR>", desc = "Pick buffer" },
      { "<leader>bC", "<Cmd>BufferLinePickClose<CR>", desc = "Pick close buffer" },
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "<leader>bc", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close other buffers" },
      { "<leader>bL", "<Cmd>BufferLineGoToBuffer -1<CR>", desc = "Go to last buffer" },
      { "<leader>bb", "<Cmd>b#<CR>", desc = "Go to previously used buffer" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseLeft<CR><Cmd>BufferLineCloseRight<CR>", desc = "Close other buffers" },
      { "<leader><", "<Cmd>BufferLineMovePrev<CR>", desc = "Move buffer left" },
      { "<leader>>", "<Cmd>BufferLineMoveNext<CR>", desc = "Move buffer right" },


      { "<leader>c", group = "code", icon = "󰨞" },
      { "<leader>f", group = "file", icon = "󰈙" },
      { "<leader>g", group = "git", icon = "󰊢" },
      { "<leader>h", group = "git [h]unks", icon = "󰊢" },
      { "<leader>l", group = "lsp", icon = "󰒋" },
      { "<leader>n", group = "notifications", icon = "󰎟" },
      { "<leader>r", group = "replace and search", icon = "󰍉" },
      { "<leader>m", group = "multicursor", icon = "󰇀" },
      { "<leader>s", group = "search", icon = "󰍉" },
      -- { "<leader>p", group = "plugins", icon = "󰏖" },
      { "<leader>t", group = "terminal", icon = "󰆍" },
      { "<leader>u", group = "ui", icon = "󰙵" },
    })
  end,
}

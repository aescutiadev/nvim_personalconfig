local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function copilot_action(action)
  local copilot = require("copilot.suggestion")
  return function()
    if copilot.is_visible() then
      copilot[action]()
      return true
    end
  end
end

---@type LazySpec
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-l>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-e>",
          },
        },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          help = true,
        },
      })
    end,
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
      opts.keymap["<Tab>"] = {
        copilot_action("accept"),
        "select_next",
        "snippet_forward",
        function(cmp)
          if has_words_before() or vim.api.nvim_get_mode().mode == "c" then
            return cmp.show()
          end
        end,
        "fallback",
      }
      opts.keymap["<C-X>"] = { copilot_action("next") }
      opts.keymap["<C-Z>"] = { copilot_action("prev") }
      opts.keymap["<C-Right>"] = { copilot_action("accept_word") }
      opts.keymap["<C-L>"] = { copilot_action("accept_word") }
      opts.keymap["<C-Down>"] = { copilot_action("accept_line") }
      opts.keymap["<C-J>"] = { copilot_action("accept_line"), "select_next", "fallback" }
      opts.keymap["<C-e>"] = { copilot_action("dismiss") }
    end,
  },
}

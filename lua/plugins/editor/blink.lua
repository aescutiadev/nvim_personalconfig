return {
  'saghen/blink.cmp',
  build = "cargo build --release",
  dependencies = {
    'saghen/blink.lib',
    -- optional: provides snippets for the snippet source
    'rafamadriz/friendly-snippets',
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "super-tab", ["<C-y>"] = { "select_and_accept" } },
    appearance = { nerd_font_variant = "mono" },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
        },
      },
    },
    signature = { enabled = true },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = { implementation = "rust" }
  },
  opts_extend = { "sources.default" },
}

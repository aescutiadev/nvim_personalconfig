return {
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {                  -- set to setup table
      rgb_fn = true,          -- CSS rgb() and rgba() functions
      hsl_fn = true,          -- CSS hsl() and hsla() functions
      oklch_fn = true,        -- CSS oklch() function
      css = true,             -- Enable all CSS *features*:
      -- names, RGB, RGBA, RRGGBB, RRGGBBAA, AARRGGBB, rgb_fn, hsl_fn, oklch_fn
      css_fn = true,          -- Enable all CSS *functions*: rgb_fn, hsl_fn, oklch_fn
      -- Tailwind colors.  boolean|'normal'|'lsp'|'both'.  True sets to 'normal'
      tailwind = 'both',      -- Enable tailwind colors
      tailwind_opts = {       -- options for highlighting tailwind names
        update_names = false, -- when using tailwind = 'both', update tailwind names from lsp results.  see tailwind section
      },
      -- parsers can contain values used in `user_default_options`
      sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
    },
  },
  {
    "MaximilianLloyd/tw-values.nvim",
    keys = {
      { "<leader>sv", "<cmd>TWValues<cr>", desc = "Show tailwind CSS values" },
    },
    opts = {
      border = "rounded",          -- Valid window border style,
      show_unknown_classes = true, -- Shows the unknown classes popup
      focus_preview = true,        -- Sets the preview as the current window
      copy_register = "",          -- The register to copy values to,
      keymaps = {
        copy = "<C-y>"             -- Normal mode keymap to copy the CSS values between {}
      }
    }
  },
}

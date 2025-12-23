local blink = {
  'saghen/blink.cmp',
  build = 'cargo build --release',
  lazy = false,
  dependencies = {
    'onsails/lspkind.nvim',
    {
      'giuxtaposition/blink-cmp-copilot',
      dependencies = { 'zbirenbaum/copilot.lua' },
    },
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
      opts = {},
    },
    'folke/lazydev.nvim',
  },
  version = '*',
  opts = {
    keymap = {
      preset = "super-tab",
      ["<C-y>"] = { "select_and_accept" },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev', 'copilot' },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        copilot = {
          name = 'copilot',
          module = 'blink-cmp-copilot',
          score_offset = 100,
          async = true,
        },
      },
    },

    snippets = { preset = 'luasnip' },

    completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        draw = {
          treesitter = { 'lsp' },
          columns = {
            { 'kind_icon' },
            { 'label',    'label_description', gap = 1 },
            { 'kind' }
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = "rounded",
          winblend = 0,
          -- Highlight groups para la ventana de docs
          winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
          max_width = 80,
          max_height = 20,
        },

      },
      ghost_text = {
        enabled = true,
      },
    },

    signature = {
      enabled = true,
      window = {
        border = "rounded",
        winblend = 0,
        winhighlight = "Normal:BlinkCmpSignature,FloatBorder:BlinkCmpSignatureBorder,EndOfBuffer:BlinkCmpSignature",
      },
    },
  },
  opts_extend = { "sources.default" },
}

return blink

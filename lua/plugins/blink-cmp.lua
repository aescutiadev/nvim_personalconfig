return {
  'saghen/blink.cmp',
  build = 'cargo build --release',
  lazy = false,
  dependencies = {
    'rafamadriz/friendly-snippets',
    'onsails/lspkind.nvim',
    {
      'giuxtaposition/blink-cmp-copilot',
      dependencies = { 'zbirenbaum/copilot.lua' },
    },
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
      default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
      providers = {
        copilot = {
          name = 'copilot',
          module = 'blink-cmp-copilot',
          score_offset = 100,
          async = true,
        },
      },
    },

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

  config = function(_, opts)
    local blink = require('blink.cmp')
    blink.setup(opts)

    -- Blink capabilities for LSP
    local capabilities = blink.get_lsp_capabilities()

    -- LSP SERVERS
    local servers = {
      "lua_ls",
      "astro",
      "mdx_analyzer",
      "marksman",
      "html",
      "tailwindcss",
    }

    for _, server in ipairs(servers) do
      vim.lsp.enable(server)
      vim.lsp.config(server, {
        capabilities = capabilities,
      })
    end

    -- DIAGNOSTICS CONFIG
    vim.diagnostic.config({
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = 'if_many',
        prefix = '●',
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = ' ',
          [vim.diagnostic.severity.WARN]  = ' ',
          [vim.diagnostic.severity.INFO]  = ' ',
          [vim.diagnostic.severity.HINT]  = '󰌵',
        },
      },
    })

    -- LSP ATTACH
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('blink.lsp', { clear = true }),

      callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local bufnr = args.buf

        -- INLAY HINTS
        local DISABLED = { lua = true, markdown = true, toml = true, help = true }

        if client.server_capabilities.inlayHintProvider then
          if not DISABLED[vim.bo[bufnr].filetype] then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
        end

        -- FORMAT ON SAVE
        if client:supports_method('textDocument/formatting') then
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = vim.api.nvim_create_augroup('blink.lsp.format', { clear = false }),
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                bufnr = bufnr,
                id = client.id,
                timeout_ms = 1000,
                async = false,
              })
            end
          })
        end

        -- LSP KEYMAPS
        local map = function(mode, keys, fn, desc)
          vim.keymap.set(mode, keys, fn, { buffer = bufnr, desc = desc })
        end

        map('n', 'gd', vim.lsp.buf.definition, 'LSP: Go to Definition')
        map('n', 'gD', vim.lsp.buf.declaration, 'LSP: Go to Declaration')
        map('n', 'gi', vim.lsp.buf.implementation, 'LSP: Go to Implementation')
        map('n', 'K', vim.lsp.buf.hover, 'LSP: Hover Documentation')
        map('n', '<leader>cr', vim.lsp.buf.rename, 'LSP: Rename')
        map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'LSP: Code Action')
        map('i', '<C-s>', vim.lsp.buf.signature_help, 'LSP: Signature Help')
      end,
    })
  end
}

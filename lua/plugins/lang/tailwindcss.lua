local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("blink.cmp").get_lsp_capabilities()
)

local lsp_name = "tailwindcss"

vim.lsp.config(lsp_name, {
  cmd = { 'tailwindcss-language-server', '--stdio' },

  capabilities = capabilities,

  -- filetypes copied and adjusted from tailwindcss-intellisense
  filetypes = {
    -- html
    'aspnetcorerazor',
    'astro',
    'astro-markdown',
    'django-html',
    'htmldjango',
    'edge',
    'gohtml',
    'gohtmltmpl',
    'hbs',
    'html',
    'htmlangular',
    'markdown',
    'mdx',
    'php',
    'blade',
    -- css
    'css',
    'less',
    'postcss',
    'sass',
    'scss',
    'stylus',
    -- js
    'javascript',
    'javascriptreact',
    'reason',
    'rescript',
    'typescript',
    'typescriptreact',
    -- mixed
    'vue',
    'svelte',
    'templ',
  },
  settings = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = 'warning',
        invalidApply = 'error',
        invalidScreen = 'error',
        invalidVariant = 'error',
        invalidConfigPath = 'error',
        invalidTailwindDirective = 'error',
        recommendedVariantOrder = 'warning',
      },
      classAttributes = {
        'class',
        'className',
        'class:list',
        'classList',
        'ngClass',
      },
      includeLanguages = {
        heex = 'phoenix-heex',
        htmlangular = 'html',
        templ = 'html',
      },
    },
  },
  before_init = function(_, config)
    if not config.settings then
      config.settings = {}
    end
    if not config.settings.editor then
      config.settings.editor = {}
    end
    if not config.settings.editor.tabSize then
      config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
    end
  end,
  workspace_required = true,

  root_dir = function(bufnr)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if fname == "" then
      return nil
    end

    local root = vim.fs.find({
      -- Tailwind v3 (si existe)
      'tailwind.config.js',
      'tailwind.config.cjs',
      'tailwind.config.mjs',
      'tailwind.config.ts',

      -- PostCSS (opcional)
      'postcss.config.js',
      'postcss.config.cjs',
      'postcss.config.mjs',
      'postcss.config.ts',

      -- Django legacy (por compatibilidad)
      'theme/static_src/tailwind.config.js',
      'theme/static_src/postcss.config.js',

      -- Tailwind v4 / fallback moderno
      'package.json',
      '.git',
    }, {
      path = fname,
      upward = true,
    })[1]

    return root and vim.fs.dirname(root) or nil
  end,
})

vim.lsp.enable(lsp_name)

return {}

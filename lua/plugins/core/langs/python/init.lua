-- Python Language Configuration
-- This file contains Python-specific configurations

return {
  -- Extend Treesitter with Python parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "python",
        "requirements", -- requirements.txt
        "toml",        -- pyproject.toml
      })
      return opts
    end,
  },

  -- Add Python LSP server (Pyright)
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.pyright = {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              typeCheckingMode = "basic",
            },
          },
        },
      }
      
      -- Alternative: pylsp (uncomment if you prefer it over pyright)
      -- opts.servers.pylsp = {
      --   settings = {
      --     pylsp = {
      --       plugins = {
      --         pycodestyle = { enabled = false },
      --         mccabe = { enabled = false },
      --         pyflakes = { enabled = false },
      --         flake8 = { enabled = true },
      --         autopep8 = { enabled = false },
      --         yapf = { enabled = false },
      --         black = { enabled = true },
      --       },
      --     },
      --   },
      -- }
      
      return opts
    end,
  },

  -- Ensure Mason installs Python LSP
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 
        "pyright", 
        -- "pylsp", -- Alternative LSP server
      })
      return opts
    end,
  },

  -- Add Python formatters
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.python = { "black", "isort" }
      
      opts.formatters = opts.formatters or {}
      opts.formatters.black = {
        prepend_args = {
          "--line-length", "88",
          "--target-version", "py38",
        },
      }
      opts.formatters.isort = {
        prepend_args = {
          "--profile", "black",
        },
      }
      
      return opts
    end,
  },

  -- Add Python linters
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.python = { "flake8", "mypy" }
      
      opts.linters = opts.linters or {}
      opts.linters.flake8 = {
        args = {
          "--max-line-length", "88",
          "--extend-ignore", "E203,W503",
          "--format", "%(path)s:%(row)d:%(col)d: %(code)s %(text)s",
          "-",
        },
      }
      
      return opts
    end,
  },

  -- Ensure Mason tools are installed
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "black",    -- Python formatter
        "isort",    -- Import sorter
        "flake8",   -- Python linter
        "mypy",     -- Type checker
      })
      return opts
    end,
  },

  -- Python development keybindings (using <leader>P to avoid conflict with plugins <leader>p)
  {
    "folke/which-key.nvim",
    config = function()
      -- Setup Python-specific keymaps when LSP attaches to Python buffers
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.name == "pyright" then
            local wk = require("which-key")
            wk.add({
              { "<leader>P", group = "python", icon = "󰌠", buffer = event.buf },
              { "<leader>Pr", "<cmd>terminal python %<cr>", desc = "Run Python file", buffer = event.buf },
              { "<leader>Pi", "<cmd>terminal python -i %<cr>", desc = "Run Python interactive", buffer = event.buf },
              { "<leader>Pt", "<cmd>terminal python -m pytest<cr>", desc = "Run pytest", buffer = event.buf },
              { "<leader>Pm", "<cmd>terminal python -m mypy %<cr>", desc = "Run mypy", buffer = event.buf },
              { "<leader>Pv", "<cmd>terminal python -m venv venv<cr>", desc = "Create virtual env", buffer = event.buf },
            })
          end
        end,
      })
    end,
  },

  -- Add Python-specific treesitter context patterns
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = function(_, opts)
      opts.patterns = opts.patterns or {}
      opts.patterns.python = {
        "class_definition",
        "function_definition",
        "method_definition",
        "if_statement",
        "for_statement",
        "while_statement",
        "with_statement",
        "try_statement",
      }
      return opts
    end,
  },
}
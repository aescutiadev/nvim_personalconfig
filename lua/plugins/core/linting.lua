return {
  -- Linter configuration - Global setup
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- Linters by filetype - will be populated by language configs
      linters_by_ft = {},
      -- Custom linters configuration
      linters = {},
    },
    config = function(_, opts)
      local lint = require("lint")
      
      -- Set linters by filetype
      lint.linters_by_ft = opts.linters_by_ft
      
      -- Override linter configurations if provided
      for name, config in pairs(opts.linters) do
        if lint.linters[name] then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], config)
        end
      end

      -- Auto-lint function
      local function lint_current_buffer()
        lint.try_lint()
      end

      -- Auto-lint autocmds
      local lint_augroup = vim.api.nvim_create_augroup("Lint", { clear = true })
      
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = lint_current_buffer,
      })

      -- Keymap to manually trigger linting
      vim.keymap.set("n", "<leader>cl", lint_current_buffer, { desc = "Lint current file" })
    end,
  },
}
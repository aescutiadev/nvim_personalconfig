local laravel = {
  "adalessa/laravel.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
  },
  ft = { "php", "blade" },
  event = {
    "BufEnter composer.json",
  },
  keys = {
    { "<leader>Ll", function() Laravel.pickers.laravel() end,              desc = "Laravel: Open Laravel Picker" },
    { "<c-g>",      function() Laravel.commands.run("view:finder") end,    desc = "Laravel: Open View Finder" },
    { "<leader>La", function() Laravel.pickers.artisan() end,              desc = "Laravel: Open Artisan Picker" },
    { "<leader>Lt", function() Laravel.commands.run("actions") end,        desc = "Laravel: Open Actions Picker" },
    { "<leader>Lr", function() Laravel.pickers.routes() end,               desc = "Laravel: Open Routes Picker" },
    { "<leader>Lh", function() Laravel.run("artisan docs") end,            desc = "Laravel: Open Documentation" },
    { "<leader>Lm", function() Laravel.pickers.make() end,                 desc = "Laravel: Open Make Picker" },
    { "<leader>Lc", function() Laravel.pickers.commands() end,             desc = "Laravel: Open Commands Picker" },
    { "<leader>Lo", function() Laravel.pickers.resources() end,            desc = "Laravel: Open Resources Picker" },
    { "<leader>Lp", function() Laravel.commands.run("command_center") end, desc = "Laravel: Open Command Center" },
    { "<leader>Lu", function() Laravel.commands.run("hub") end,            desc = "Laravel Artisan hub" },
    {
      "gf",
      function()
        local ok, res = pcall(function()
          if Laravel.app("gf").cursorOnResource() then
            return "<cmd>lua Laravel.commands.run('gf')<cr>"
          end
        end)
        if not ok or not res then
          return "gf"
        end
        return res
      end,
      expr = true,
      noremap = true,
    },
  },
  opts = {
    features = {
      pickers = {
        provider = "snacks", -- "snacks | telescope | fzf-lua | ui-select"
      },
    },
  },
}

local laravel_ide_helper = {
    "Bleksak/laravel-ide-helper.nvim",
    opts = {
        save_before_write = true,
        format_after_gen = true,
        models_args = {},
    },
    enabled = function()
        return vim.fn.filereadable("artisan") ~= 0
    end,
    keys = {
        { "<leader>Lgm", function() require("laravel-ide-helper").generate_models(vim.fn.expand("%")) end, desc = "Generate Model Info for current model" },
        { "<leader>LgM", function() require("laravel-ide-helper").generate_models() end, desc = "Generate Model Info for all models" },
    }
}

local blade_nav = {
    'ricardoramirezr/blade-nav.nvim',
    dependencies = { -- totally optional
        'saghen/blink.cmp',                    -- if using blink.cmp
    },
    ft = {'blade', 'php'}, -- optional, improves startup time
    opts = {
        -- This applies for nvim-cmp and coq, for blink refer to the configuration of this plugin
        close_tag_on_complete = true, -- default: true
    },
}

return { laravel, laravel_ide_helper, blade_nav }

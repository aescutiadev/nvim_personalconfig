local default_opts = { instanceName = "main" }

local function grug_far_open(opts, with_visual)
  local grug_far = require("grug-far")
  opts = vim.tbl_extend("force", default_opts, opts or {})
  if not grug_far.has_instance(opts.instanceName) then
    grug_far.open(opts)
  else
    if with_visual then
      opts.prefills = opts.prefills or {}
      opts.prefills.search = grug_far.get_current_visual_selection()
    end
    grug_far.open_instance(opts.instanceName)
    if opts.prefills then
      grug_far.update_instance_prefills(opts.instanceName, opts.prefills, false)
    end
  end
end

local prefix = "<Leader>r"

return {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar", "GrugFarWithin" },
  keys = {
    { prefix .. "s", function() grug_far_open() end,          desc = "Search/Replace workspace" },
    {
      prefix .. "e",
      function()
        local ext = vim.fn.expand("%:e")
        grug_far_open { prefills = { filesFilter = (ext ~= "" and "*." .. ext or nil) } }
      end,
      desc = "Search/Replace filetype"
    },
    {
      prefix .. "f",
      function()
        local filter = vim.fn.fnameescape(vim.fn.expand("%"))
        grug_far_open { prefills = { paths = filter } }
      end,
      desc = "Search/Replace file"
    },
    {
      prefix .. "w",
      function()
        local current_word = vim.fn.expand("<cword>")
        if current_word ~= "" then
          grug_far_open { startCursorRow = 4, prefills = { search = current_word } }
        else
          vim.notify("No word under cursor", vim.log.levels.WARN, { title = "GrugFar" })
        end
      end,
      desc = "Replace current word"
    },
    { prefix, function() grug_far_open(nil, true) end, mode = "x", desc = "Replace selection" },
  },
  opts = {
    transient = true,
    icons = {},
  },
  config = function(_, opts)
    local grug_far = require("grug-far")
    grug_far.setup(opts)

    if vim.g.icons_enabled == false then
      grug_far.setup {
        icons = { enabled = false },
        resultsSeparatorLineChar = "-",
        spinnerStates = { "|", "\\", "-", "/" },
      }
    end

    -- Integración con neo-tree
    local present, neo_tree = pcall(require, "neo-tree")
    if present then
      neo_tree.setup {
        commands = {
          grug_far_replace = function(state)
            local node = state.tree:get_node()
            local path = node.type == "directory" and node:get_id() or vim.fn.fnamemodify(node:get_id(), ":h")
            grug_far_open { prefills = { paths = path } }
          end,
        },
        window = {
          mappings = {
            gS = "grug_far_replace",
          },
        },
      }
    end
  end,
}

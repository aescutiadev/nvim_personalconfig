local default_opts = { instanceName = "main" }
local prefix = "<Leader>r"

vim.pack.add({
  {
    src = "https://github.com/MagicDuck/grug-far.nvim",
  },
})

local function ensure_loaded()
  local grug_far = require("grug-far")

  grug_far.setup({
    transient = true,
    icons = {},
  })

  if vim.g.icons_enabled == false then
    grug_far.setup({
      icons = { enabled = false },
      resultsSeparatorLineChar = "-",
      spinnerStates = { "|", "\\", "-", "/" },
    })
  end

  -- Neo-tree integration
  local ok, neo_tree = pcall(require, "neo-tree")
  if ok then
    neo_tree.setup({
      commands = {
        grug_far_replace = function(state)
          local node = state.tree:get_node()

          local path = node.type == "directory"
              and node:get_id()
              or vim.fn.fnamemodify(node:get_id(), ":h")

          grug_far.open({
            prefills = {
              paths = path,
            },
          })
        end,
      },

      window = {
        mappings = {
          gS = "grug_far_replace",
        },
      },
    })
  end
end

--------------------------------------------------------------------------------
-- Helper
--------------------------------------------------------------------------------

local function grug_far_open(opts, with_visual)
  ensure_loaded()

  local grug_far = require("grug-far")

  opts = vim.tbl_extend("force", default_opts, opts or {})

  if not grug_far.has_instance(opts.instanceName) then
    grug_far.open(opts)
    return
  end

  if with_visual then
    opts.prefills = opts.prefills or {}
    opts.prefills.search = grug_far.get_current_visual_selection()
  end

  grug_far.open(opts.instanceName)

  if opts.prefills then
    grug_far.get_instance(
      opts.instanceName
    ):update_input_values(opts.prefills, false)
  end
end

--------------------------------------------------------------------------------
-- Stub commands
--------------------------------------------------------------------------------

local function command_stub(name)
  vim.api.nvim_create_user_command(name, function(opts)
    vim.api.nvim_del_user_command(name)

    ensure_loaded()

    vim.cmd({
      cmd = name,
      args = opts.fargs,
      bang = opts.bang,
    })
  end, {
    nargs = "*",
    bang = true,
  })
end

command_stub("GrugFar")
command_stub("GrugFarWithin")

--------------------------------------------------------------------------------
-- Keymaps
--------------------------------------------------------------------------------

vim.keymap.set("n", prefix .. "s", function()
  grug_far_open()
end, { desc = "Search/Replace workspace" })

vim.keymap.set("n", prefix .. "e", function()
  local ext = vim.fn.expand("%:e")

  grug_far_open({
    prefills = {
      filesFilter = ext ~= "" and "*." .. ext or nil,
    },
  })
end, { desc = "Search/Replace filetype" })

vim.keymap.set("n", prefix .. "f", function()
  grug_far_open({
    prefills = {
      paths = vim.fn.fnameescape(vim.fn.expand("%")),
    },
  })
end, { desc = "Search/Replace file" })

vim.keymap.set("n", prefix .. "w", function()
  local word = vim.fn.expand("<cword>")

  if word == "" then
    vim.notify("No word under cursor", vim.log.levels.WARN, {
      title = "GrugFar",
    })
    return
  end

  grug_far_open({
    startCursorRow = 4,
    prefills = {
      search = word,
      paths = vim.fn.fnameescape(vim.fn.expand("%")),
    },
  })
end, { desc = "Replace current word" })

vim.keymap.set("x", prefix, function()
  grug_far_open(nil, true)
end, { desc = "Replace selection" })

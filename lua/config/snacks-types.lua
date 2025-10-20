-- Snacks Integration for Better LSP Support
-- This file helps LSP understand Snacks types better

---@diagnostic disable: duplicate-set-field

-- Global Snacks definition for runtime (safe loading)
local function setup_snacks_global()
  local has_snacks, snacks = pcall(require, "snacks")
  if has_snacks and not _G.Snacks then
    ---@type Snacks
    _G.Snacks = snacks
  end
end

-- Try to set up immediately if available
setup_snacks_global()

-- Set up after plugins are loaded
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  callback = setup_snacks_global,
  once = true,
})

-- Also try when Snacks is loaded specifically
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy", 
  callback = setup_snacks_global,
  once = true,
})
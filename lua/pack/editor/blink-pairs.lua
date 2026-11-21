vim.pack.add({
  'https://github.com/saghen/blink.lib',
  { src = 'https://github.com/saghen/blink.pairs', version = vim.version.range('*') },
})

-- El download del binario tampoco va en el arranque: `pwait()` bloquea hasta
-- 60 s si hay que bajar la release. Sólo en install/update.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local spec = ev.data.spec
    if spec and spec.name == "blink.pairs" and (ev.data.kind == "install" or ev.data.kind == "update") then
      vim.schedule(function()
        require('blink.pairs').download():pwait(60000)
      end)
    end
  end,
})

-- see above for the config
require('blink.pairs').setup({
  mappings = {
    -- you can call require("blink.pairs.mappings").enable()
    -- and require("blink.pairs.mappings").disable()
    -- to enable/disable mappings at runtime
    enabled = true,
    cmdline = true,
    -- or disable with `vim.g.pairs = false` (global) and `vim.b.pairs = false` (per-buffer)
    -- and/or with `vim.g.blink_pairs = false` and `vim.b.blink_pairs = false`
    disabled_filetypes = {},
    wrap = {
      -- move closing pair via motion
      ['<C-b>'] = 'motion',
      -- move opening pair via motion
      ['<C-S-b>'] = 'motion_reverse',
      -- set to 'treesitter' or 'treesitter_reverse' to use treesitter instead of motions
      -- set to nil, '' or false to disable the mapping
      -- normal_mode = {} <- for normal mode mappings, only supports 'motion' and 'motion_reverse'
    },
    -- see the defaults:
    -- https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L52
    pairs = {},
  },
  highlights = {
    enabled = true,
    -- requires require('vim._core.ui2').enable({}), otherwise has no effect
    cmdline = true,
    -- set to { 'BlinkPairs' } to disable rainbow highlighting
    groups = { 'BlinkPairsOrange', 'BlinkPairsPurple', 'BlinkPairsBlue' },
    unmatched_group = 'BlinkPairsUnmatched',

    -- highlights matching pairs under the cursor
    matchparen = {
      enabled = true,
      -- known issue where typing won't update matchparen highlight, disabled by default
      cmdline = false,
      -- also include pairs not on top of the cursor, but surrounding the cursor
      include_surrounding = false,
      group = 'BlinkPairsMatchParen',
      priority = 250,
    },
  },
  debug = false,
})

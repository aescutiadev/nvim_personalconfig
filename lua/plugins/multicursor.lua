return {
  "brenton-leighton/multiple-cursors.nvim",
  version = "*",
  opts = {},
  keys = {
    -- Movimiento básico
    { "<C-j>",         "<Cmd>MultipleCursorsAddDown<CR>",          mode = { "n", "x" },      desc = "Add cursor and move down" },
    { "<C-k>",         "<Cmd>MultipleCursorsAddUp<CR>",            mode = { "n", "x" },      desc = "Add cursor and move up" },
    { "<C-Up>",        "<Cmd>MultipleCursorsAddUp<CR>",            mode = { "n", "i", "x" }, desc = "Add cursor and move up" },
    { "<C-Down>",      "<Cmd>MultipleCursorsAddDown<CR>",          mode = { "n", "i", "x" }, desc = "Add cursor and move down" },
    -- Mouse
    { "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>",   mode = { "n", "i" },      desc = "Add or remove cursor with mouse" },
    -- Área visual
    { "<Leader>mm",    "<Cmd>MultipleCursorsAddVisualArea<CR>",    mode = { "x" },           desc = "Add cursors to lines in visual area" },
    -- Matches por palabra o selección
    { "<Leader>ma",    "<Cmd>MultipleCursorsAddMatches<CR>",       mode = { "n", "x" },      desc = "Add cursors to matches of word under cursor" },
    { "<Leader>mA",    "<Cmd>MultipleCursorsAddMatchesV<CR>",      mode = { "n", "x" },      desc = "Add cursors to matches in previous area" },
    { "<Leader>md",    "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = { "n", "x" },      desc = "Add cursor then jump to next match" },
    { "<Leader>mD",    "<Cmd>MultipleCursorsJumpNextMatch<CR>",    mode = { "n", "x" },      desc = "Jump to next match" },
    -- Lock
    { "<Leader>mk",    "<Cmd>MultipleCursorsLock<CR>",             mode = { "n", "x" },      desc = "Lock virtual cursors" },

    -- Pattern manual
    {
      "<Leader>mp",
      function()
        vim.ui.input({ prompt = "Pattern: " }, function(pattern)
          if pattern and pattern ~= "" then
            vim.cmd("MultipleCursorsAddMatches " .. pattern)
          end
        end)
      end,
      desc = "Add cursors with pattern",
      mode = { "n" }
    },

    -- Borrar cursores
    { "<Leader>mc", "<Cmd>MultipleCursorsClear<CR>",          mode = { "n", "x" }, desc = "Clear all cursors" },
    -- Navegar entre cursores
    { "<Leader>mn", "<Cmd>MultipleCursorsNext<CR>",           mode = { "n" },      desc = "Next cursor" },
    { "<Leader>mN", "<Cmd>MultipleCursorsPrev<CR>",           mode = { "n" },      desc = "Previous cursor" },
    -- Visual lines
    { "<Leader>ml", "<Cmd>MultipleCursorsAddVisualLines<CR>", mode = { "x" },      desc = "Add cursors per line (visual)" },
  },
}

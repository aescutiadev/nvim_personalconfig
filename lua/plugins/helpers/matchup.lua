local matchup = {
  "andymass/vim-matchup",
  opts = {
    treesitter = {
      stopline = 500,
    }
  }
}
-- TwoSlash queries - Anotaciones TypeScript inline
local template_string = {
  "axelvc/template-string.nvim",
  event = "InsertEnter",
  ft = { 'html', 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue', 'svelte', 'python', 'cs' },
  config = true,   -- run require("template-string").setup()
}

return { matchup, template_string }

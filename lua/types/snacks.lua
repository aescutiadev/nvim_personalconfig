---@meta snacks

---@class Snacks
---@field picker SnacksPicker
---@field notifier SnacksNotifier
---@field terminal SnacksTerminal
---@field toggle SnacksToggle
---@field zen SnacksZen
---@field scratch SnacksScratch
---@field debug SnacksDebug
---@field bufdelete function
---@field rename SnacksRename
---@field gitbrowse function
---@field lazygit function
---@field explorer function
---@field win function
Snacks = {}

---@class SnacksPicker
---@field smart function
---@field files function
---@field buffers function
---@field grep function
---@field grep_word function
---@field grep_buffers function
---@field command_history function
---@field search_history function
---@field notifications function
---@field git_files function
---@field git_branches function
---@field git_log function
---@field git_log_line function
---@field git_log_file function
---@field git_status function
---@field git_stash function
---@field git_diff function
---@field projects function
---@field recent function
---@field registers function
---@field autocmds function
---@field lines function
---@field commands function
---@field diagnostics function
---@field diagnostics_buffer function
---@field help function
---@field highlights function
---@field icons function
---@field jumps function
---@field keymaps function
---@field loclist function
---@field marks function
---@field man function
---@field lazy function
---@field qflist function
---@field resume function
---@field undo function
---@field colorschemes function
---@field lsp_definitions function
---@field lsp_declarations function
---@field lsp_references function
---@field lsp_implementations function
---@field lsp_type_definitions function
---@field lsp_symbols function
---@field lsp_workspace_symbols function

---@class SnacksNotifier
---@field show_history function
---@field hide function

---@class SnacksTerminal

---@class SnacksToggle
---@field option function
---@field diagnostics function
---@field line_number function
---@field treesitter function
---@field inlay_hints function
---@field indent function
---@field dim function

---@class SnacksZen
---@field zoom function

---@class SnacksScratch
---@field select function

---@class SnacksDebug
---@field inspect function
---@field backtrace function

---@class SnacksRename
---@field rename_file function


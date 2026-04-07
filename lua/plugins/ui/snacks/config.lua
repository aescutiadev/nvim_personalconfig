local excludeData = {
  ".git",
  "node_modules",
  "dist",
  "build",
  ".cache",
  "package-lock.json",
  "target",
  "pnpm-lock.json",
  "bun.lock",
  "yarn.lock",
  "vendor",
  "__pycache__",
  ".DS_Store",
}

local map = vim.keymap.set

-- Top Pickers & Explorer
map("n", "<leader>fs", function() Snacks.picker.smart() end,                         { desc = "Smart Find Files" })
map("n", "<leader>,",  function() Snacks.picker.buffers({ current = false }) end,    { desc = "Buffers" })
map("n", "<leader>/",  function() Snacks.picker.grep({ exclude = excludeData }) end, { desc = "Grep" })
map("n", "<leader>:",  function() Snacks.picker.command_history() end,               { desc = "Command History" })
map("n", "<leader>n",  function() Snacks.picker.notifications() end,                 { desc = "Notification History" })
map("n", "<leader>e",  function() Snacks.explorer() end,                             { desc = "File Explorer" })

-- Find
map("n", ",",          function() Snacks.picker.files({ exclude = excludeData }) end,                { desc = "Find Files" })
map("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,      { desc = "Find Config File" })
map("n", "<leader>fb", function() Snacks.picker.buffers({ current = false }) end,                    { desc = "Buffers" })
map("n", "<leader>fg", function() Snacks.picker.git_files() end,                                     { desc = "Find Git Files" })
map("n", "<leader>fp", function() Snacks.picker.projects() end,                                      { desc = "Projects" })
map("n", "<leader>fr", function() Snacks.picker.recent() end,                                        { desc = "Recent" })

-- Git
map("n", "<leader>gb", function() Snacks.picker.git_branches() end,  { desc = "Git Branches" })
map("n", "<leader>gl", function() Snacks.picker.git_log() end,        { desc = "Git Log" })
map("n", "<leader>gL", function() Snacks.picker.git_log_line() end,   { desc = "Git Log Line" })
map("n", "<leader>gs", function() Snacks.picker.git_status() end,     { desc = "Git Status" })
map("n", "<leader>gS", function() Snacks.picker.git_stash() end,      { desc = "Git Stash" })
map("n", "<leader>gd", function() Snacks.picker.git_diff() end,       { desc = "Git Diff (Hunks)" })
map("n", "<leader>gf", function() Snacks.picker.git_log_file() end,   { desc = "Git Log File" })

-- GitHub
map("n", "<leader>gi", function() Snacks.picker.gh_issue() end,                  { desc = "GitHub Issues (open)" })
map("n", "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, { desc = "GitHub Issues (all)" })
map("n", "<leader>gp", function() Snacks.picker.gh_pr() end,                     { desc = "GitHub Pull Requests (open)" })
map("n", "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end,    { desc = "GitHub Pull Requests (all)" })

-- Grep
map("n",          "<leader>sb", function() Snacks.picker.lines() end,                              { desc = "Buffer Lines" })
map("n",          "<leader>sB", function() Snacks.picker.grep_buffers() end,                       { desc = "Grep Open Buffers" })
map("n",          "<leader>sg", function() Snacks.picker.grep({ exclude = excludeData }) end,      { desc = "Grep" })
map({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word({ exclude = excludeData }) end, { desc = "Visual selection or word" })

-- Search
map("n", '<leader>s"', function() Snacks.picker.registers() end,         { desc = "Registers" })
map("n", '<leader>s/', function() Snacks.picker.search_history() end,    { desc = "Search History" })
map("n", "<leader>sa", function() Snacks.picker.autocmds() end,          { desc = "Autocmds" })
map("n", "<leader>sc", function() Snacks.picker.command_history() end,   { desc = "Command History" })
map("n", "<leader>sC", function() Snacks.picker.commands() end,          { desc = "Commands" })
map("n", "<leader>sd", function() Snacks.picker.diagnostics() end,       { desc = "Diagnostics" })
map("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end,{ desc = "Buffer Diagnostics" })
map("n", "<leader>sh", function() Snacks.picker.help() end,              { desc = "Help Pages" })
map("n", "<leader>sH", function() Snacks.picker.highlights() end,        { desc = "Highlights" })
map("n", "<leader>si", function() Snacks.picker.icons() end,             { desc = "Icons" })
map("n", "<leader>sj", function() Snacks.picker.jumps() end,             { desc = "Jumps" })
map("n", "<leader>sk", function() Snacks.picker.keymaps() end,           { desc = "Keymaps" })
map("n", "<leader>sl", function() Snacks.picker.loclist() end,           { desc = "Location List" })
map("n", "<leader>sm", function() Snacks.picker.marks() end,             { desc = "Marks" })
map("n", "<leader>sM", function() Snacks.picker.man() end,               { desc = "Man Pages" })
map("n", "<leader>sp", function() Snacks.picker.lazy() end,              { desc = "Search for Plugin Spec" })
map("n", "<leader>sq", function() Snacks.picker.qflist() end,            { desc = "Quickfix List" })
map("n", "<leader>sR", function() Snacks.picker.resume() end,            { desc = "Resume" })
map("n", "<leader>su", function() Snacks.picker.undo() end,              { desc = "Undo History" })
map("n", "<leader>uC", function() Snacks.picker.colorschemes() end,      { desc = "Colorschemes" })

-- LSP
map("n", "gd",         function() Snacks.picker.lsp_definitions() end,       { desc = "Goto Definition" })
map("n", "gD",         function() Snacks.picker.lsp_declarations() end,      { desc = "Goto Declaration" })
map("n", "gr",         function() Snacks.picker.lsp_references() end,        { nowait = true, desc = "References" })
map("n", "gI",         function() Snacks.picker.lsp_implementations() end,   { desc = "Goto Implementation" })
map("n", "gy",         function() Snacks.picker.lsp_type_definitions() end,  { desc = "Goto T[y]pe Definition" })
map("n", "gai",        function() Snacks.picker.lsp_incoming_calls() end,    { desc = "C[a]lls Incoming" })
map("n", "gao",        function() Snacks.picker.lsp_outgoing_calls() end,    { desc = "C[a]lls Outgoing" })
map("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end,           { desc = "LSP Symbols" })
map("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })

-- Other
map("n",          "<leader>z",  function() Snacks.zen() end,                  { desc = "Toggle Zen Mode" })
map("n",          "<leader>Z",  function() Snacks.zen.zoom() end,             { desc = "Toggle Zoom" })
map("n",          "<leader>.",  function() Snacks.scratch() end,              { desc = "Toggle Scratch Buffer" })
map("n",          "<leader>S",  function() Snacks.scratch.select() end,       { desc = "Select Scratch Buffer" })
map("n",          "<leader>n",  function() Snacks.notifier.show_history() end,{ desc = "Notification History" })
map("n",          "<leader>cR", function() Snacks.rename.rename_file() end,   { desc = "Rename File" })
map({ "n", "v" }, "<leader>gB", function() Snacks.gitbrowse() end,            { desc = "Git Browse" })
map("n",          "<leader>gg", function() Snacks.lazygit() end,              { desc = "Lazygit" })
map("n",          "<leader>un", function() Snacks.notifier.hide() end,        { desc = "Dismiss All Notifications" })
map("n",          "<leader>tt", function() Snacks.terminal() end,             { desc = "Toggle Terminal" })
map("n",          "<leader>ti", function() Snacks.terminal() end,             { desc = "which_key_ignore" })
map({ "n", "t" }, "]]",         function() Snacks.words.jump(vim.v.count1) end,  { desc = "Next Reference" })
map({ "n", "t" }, "[[",         function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })
map("n", "<leader>N", function()
  Snacks.win({
    file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
    width = 0.6,
    height = 0.6,
    wo = {
      spell = false,
      wrap = false,
      signcolumn = "yes",
      statuscolumn = " ",
      conceallevel = 3,
    },
  })
end, { desc = "Neovim News" })

-- Inicialización diferida: equivalente a lazy.nvim "init", usando VimEnter
-- (VeryLazy es un evento de lazy.nvim y no existe en vim.pack)
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    _G.dd = function(...)
      Snacks.debug.inspect(...)
    end
    _G.bt = function()
      Snacks.debug.backtrace()
    end

    vim._print = function(_, ...)
      dd(...)
    end

    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
    Snacks.toggle.diagnostics():map("<leader>ud")
    Snacks.toggle.line_number():map("<leader>ul")
    Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
    Snacks.toggle.treesitter():map("<leader>uT")
    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
    Snacks.toggle({
      name = "Inlay Hints (Global)",
      get = function()
        return vim.g.inlay_hints_enabled or false
      end,
      set = function(state)
        vim.g.inlay_hints_enabled = state
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) and #vim.lsp.get_clients({ bufnr = buf }) > 0 then
            vim.lsp.inlay_hint.enable(state, { bufnr = buf })
          end
        end
      end,
    }):map("<leader>uh")
    Snacks.toggle.indent():map("<leader>ug")
    Snacks.toggle.dim():map("<leader>uD")
  end,
})

require("snacks.nvim").setup({
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = table.concat({
          "                                                                 ",
          "   █████╗ ███████╗███████╗ ██████╗██╗   ██╗████████╗██╗ █████╗   ",
          "  ██╔══██╗██╔════╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔══██╗  ",
          "  ███████║█████╗  ███████╗██║     ██║   ██║   ██║   ██║███████║  ",
          "  ██╔══██║██╔══╝  ╚════██║██║     ██║   ██║   ██║   ██║██╔══██║  ",
          "  ██║  ██║███████╗███████║╚██████╗╚██████╔╝   ██║   ██║██║  ██║  ",
          "  ╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝╚═╝  ╚═╝  ",
          "                                                                 ",
          "                     ██████╗ ███████╗██╗   ██╗                   ",
          "                     ██╔══██╗██╔════╝██║   ██║                   ",
          "                     ██║  ██║█████╗  ██║   ██║                   ",
          "                     ██║  ██║██╔══╝  ╚██╗ ██╔╝                   ",
          "                     ██████╔╝███████╗ ╚████╔╝                    ",
          "                     ╚═════╝ ╚══════╝  ╚═══╝                     ",
          "                                                                 ",
        }, "\n"),
      },
      sections = {
        { section = "header" },
        { section = "keys",  gap = 1,    padding = 1 },
        { pane = 1,          icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        {
          pane = 1,
          icon = " ",
          desc = "Browse Repo",
          padding = 1,
          key = "b",
          action = function()
            Snacks.gitbrowse()
          end,
        },
        {
          pane = 1,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = "startup" },
      },
      keys = {
        { key = "g", action = false },
      },
    },
    explorer = { enabled = false },
    indent = {
      indent = { enabled = false },
      scope = {
        enabled = true,
        only_current = true,
        only_scope = true,
        char = "│",
      },
    },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 6000,
    },
    picker = { enabled = true, use_icons = true, ui_select = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true }
      }
    }
})


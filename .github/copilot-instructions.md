# Copilot Instructions — Neovim Configuration

## Architecture

Personal Neovim 0.11.6+ configuration using Lazy.nvim. Structure follows domain-based organization per `RULES.md`.

**Load order** (`init.lua`):
1. `core.options` — editor settings (`vim.opt`)
2. `core.keymaps` — global keybindings
3. `core.autocmds` — autocommands
4. `core.diagnostics` — diagnostic configuration
5. `core.lazy` — bootstraps Lazy.nvim and loads plugins
6. `lsp` — LSP capabilities, handlers, and server activation

**Plugin specs** are organized by domain in `lua/plugins/`, one file per plugin:
- `init.lua` — generic plugins (devicons, mini.icons)
- `ui/` — UI plugins (catppuccin, neo-tree, snacks, which-key, lualine)
- `editor/` — editor behavior (treesitter, blink.cmp, gitsigns, flash, pairs, todo-comments, matchup, template-string, colorizer)
- `lsp/` — LSP-related plugins (mason)
- `tools/` — tool plugins (grug-far, schemastore, package-info, tsc)

**Module directories** (non-plugin logic):
- `lua/lsp/` — LSP bootstrap (`init.lua`), capabilities (`capabilities.lua`), handlers (`handlers.lua`)
- `lua/editor/` — treesitter, folding, completion, formatting logic

**Native LSP server configs** (`lsp/` at config root):
- One file per server (e.g., `lsp/lua_ls.lua`, `lsp/vtsls.lua`, `lsp/tailwindcss.lua`)
- Each returns a `vim.lsp.Config` table with `cmd`, `filetypes`, `root_markers`, and `settings`
- Auto-discovered by Neovim 0.11.6
- Enable servers via `vim.lsp.enable()` in `lua/lsp/init.lua`

**Filetype overrides**: `after/ftplugin/` for per-language buffer-local settings.

**Key frameworks**:
- **Snacks.nvim** — pickers, notifications, git, terminal, zen mode, LSP navigation
- **Neo-tree** — file explorer (left panel, `<leader>e`)
- **blink.cmp** — completion engine with LSP, snippets, path, buffer sources
- **Catppuccin Mocha** — colorscheme
- No nvim-lspconfig — uses native `vim.lsp.enable()`

## Conventions

- All configuration in **Lua**, **2-space indentation**
- Comments often in **Spanish**
- Leader: `<Space>`, local leader: `,` (keymaps.lua) / `\` (lazy.lua)
- Each plugin file returns a single Lazy.nvim spec table (or a list for tightly coupled plugins)
- Keymaps use `vim.keymap.set` (aliased `map.set` in keymaps.lua)
- Autocmd groups use `augroup()` helper with `clear = true`

## Adding a New Language

1. Create `lsp/<server_name>.lua` at the config root with `cmd`, `filetypes`, `root_markers`, and `settings`
2. Add `vim.lsp.enable('<server_name>')` in `lua/lsp/init.lua`
3. Add Treesitter parser to `ensure_installed` in `lua/editor/treesitter.lua`
4. Optionally add `after/ftplugin/<filetype>.lua` for buffer-local settings

## Adding a New Plugin

1. Create a new file in the appropriate domain subdirectory: `lua/plugins/<domain>/<plugin>.lua`
2. The file returns a single Lazy.nvim spec table
3. Lazy.nvim auto-discovers it via `{ import = "plugins.<domain>" }` in `lua/core/lazy.lua`

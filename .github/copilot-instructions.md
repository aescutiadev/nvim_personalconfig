# Copilot Instructions — Neovim Configuration

## Architecture

Personal Neovim 0.11.6+ configuration using Lazy.nvim. Structure follows domain-based organization per `RULES.md`.

**Load order** (`init.lua`):
1. `core.options` — editor settings (`vim.opt`)
2. `core.keymaps` — global keybindings
3. `core.autocmds` — autocommands
4. `core.diagnostics` — diagnostic configuration
5. `core.lazy` — bootstraps Lazy.nvim and loads plugins

**Plugin specs** are organized by domain in `lua/plugins/`:
- `init.lua` — generic plugins (devicons, mini.icons)
- `ui.lua` — UI plugins (catppuccin, neo-tree, snacks, which-key)
- `editor.lua` — editor behavior (treesitter, todo-comments)
- `lsp.lua` — LSP-related plugins (mason)
- `tools.lua` — tool plugins

**Module directories** (non-plugin logic):
- `lua/lsp/` — LSP bootstrap, capabilities, handlers
- `lua/ui/` — statusline, winbar, highlights logic
- `lua/editor/` — treesitter, folding, completion, formatting logic
- `lua/utils/` — reusable helpers and icons

**Native LSP server configs** (`lsp/` at config root):
- One file per server (e.g., `lsp/lua_ls.lua`, `lsp/astro.lua`)
- Each returns a config table, auto-discovered by Neovim 0.11.6
- Enable servers via `vim.lsp.enable()` in `lua/lsp/init.lua`

**Filetype overrides**: `after/ftplugin/` for per-language buffer-local settings.

**Key frameworks**:
- **Snacks.nvim** — pickers, notifications, git, terminal, zen mode, LSP navigation
- **Neo-tree** — file explorer (left panel, `<leader>e`)
- **Catppuccin Mocha** — colorscheme
- No nvim-lspconfig — uses native `vim.lsp.enable()`

## Conventions

- All configuration in **Lua**, **2-space indentation**
- Comments often in **Spanish**
- Leader: `<Space>`, local leader: `,` (keymaps.lua) / `\` (lazy.lua)
- Plugin files return Lazy.nvim spec tables
- Keymaps use `vim.keymap.set` (aliased `map.set` in keymaps.lua)
- Autocmd groups use `augroup()` helper with `clear = true`

## Adding a New Language

1. Create `lsp/<server_name>.lua` at the config root with the server config
2. Add `vim.lsp.enable('<server_name>')` in `lua/lsp/init.lua`
3. Add Treesitter parser to `ensure_installed` in `lua/plugins/editor.lua`
4. Optionally add `after/ftplugin/<filetype>.lua` for buffer-local settings

## Adding a New Plugin

1. Add the spec to the appropriate domain file in `lua/plugins/` (ui, editor, lsp, tools)
2. Plugin specs are organized by domain, not by individual plugin name

# Copilot Instructions — Neovim Configuration

Se usa NEOVIM 0.11.6

## Architecture

Personal Neovim 0.11.6+ configuration using Lazy.nvim. Structure follows domain-based organization.

### Estructura del proyecto

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lazy-lock.json              # Plugin version lock
├── lsp/                        # Native LSP server configs (vim.lsp.Config)
│   ├── lua_ls.lua
│   ├── vtsls.lua
│   ├── cssls.lua
│   ├── css_variables.lua
│   ├── tailwindcss.lua
│   ├── html.lua
│   ├── astro.lua
│   ├── marksman.lua
│   ├── rust_analyzer.lua
│   ├── taplo.lua
│   ├── yamlls.lua
│   ├── jsonls.lua
│   └── bashls.lua
├── after/ftplugin/             # Per-language buffer-local settings
│   ├── lua.lua
│   ├── astro.lua
│   ├── markdown.lua            # spell en/es
│   └── gitcommit.lua           # spell en/es
└── lua/
    ├── core/                   # Core configuration (always loaded, no plugin deps)
    │   ├── options.lua         # vim.opt settings
    │   ├── keymaps.lua         # Global keybindings
    │   ├── autocmds.lua        # Auto-commands (bigfile, format on save, etc.)
    │   ├── diagnostics.lua     # Diagnostic config + keymaps
    │   └── lazy.lua            # Lazy.nvim bootstrap
    ├── lsp/                    # LSP logic modules
    │   ├── init.lua            # vim.lsp.enable() for all servers
    │   ├── capabilities.lua    # blink.cmp capabilities injection
    │   └── handlers.lua        # LspAttach: keymaps, document highlight, inlay hints
    ├── editor/                 # Editor logic modules
    │   ├── treesitter.lua      # Treesitter setup + ensure_installed
    │   ├── completion.lua      # Completion settings
    │   ├── folding.lua         # Fold enhancements
    │   └── formatting.lua      # Format commands
    └── plugins/                # Plugin specs (one file per plugin)
        ├── init.lua            # devicons, mini.icons
        ├── ui/                 # catppuccin, neo-tree, snacks, which-key, lualine
        ├── editor/             # treesitter, blink, gitsigns, flash, pairs, matchup, etc.
        ├── lsp/                # mason
        └── tools/              # grug-far, schemastore, package-info, tsc, copilot, mcphub
```

### Load order (`init.lua`)

1. `core.options` — editor settings (`vim.opt`)
2. `core.keymaps` — global keybindings
3. `core.autocmds` — autocommands (bigfile detection, format on save, etc.)
4. `core.diagnostics` — diagnostic configuration
5. `core.lazy` — bootstraps Lazy.nvim and loads plugins
6. `lsp` — LSP capabilities, handlers, and server activation

### Key frameworks

- **Snacks.nvim** — pickers, notifications, git, terminal, zen mode, LSP navigation
- **Neo-tree** — file explorer (left panel, `<leader>e`)
- **blink.cmp** — completion engine with LSP, snippets, path, buffer sources
- **Catppuccin Mocha** — colorscheme
- **MCPHub** — MCP server integration (per-project `.mcphub/servers.json`)
- **CopilotChat** — AI chat with MCPHub extension
- No nvim-lspconfig — uses native `vim.lsp.enable()`

## Conventions

- All configuration in **Lua**, **2-space indentation**
- Comments often in **Spanish**
- Leader: `<Space>`, local leader: `\`
- Each plugin file returns a single Lazy.nvim spec table (or a list for tightly coupled plugins)
- Keymaps use `vim.keymap.set` (aliased `map.set` in keymaps.lua)
- Autocmd groups use `augroup()` helper with `clear = true`
- **Bigfile detection** (>1MB): autocmd in `autocmds.lua` disables treesitter, syntax, LSP, folds, spell for performance
- **Format on save**: disabled by default, toggle with `<leader>uf`
- **Project-local config**: `opt.exrc = true` loads `.nvim.lua` per project

## Adding a New Language

1. Create `lsp/<server_name>.lua` at the config root with `cmd`, `filetypes`, `root_markers`, and `settings`
2. Add `vim.lsp.enable('<server_name>')` in `lua/lsp/init.lua`
3. Add Treesitter parser to `ensure_installed` in `lua/editor/treesitter.lua`
4. Optionally add `after/ftplugin/<filetype>.lua` for buffer-local settings (spell, indent overrides)

## Adding a New Plugin

1. Create a new file in the appropriate domain subdirectory: `lua/plugins/<domain>/<plugin>.lua`
2. The file returns a single Lazy.nvim spec table
3. Lazy.nvim auto-discovers it via `{ import = "plugins.<domain>" }` in `lua/core/lazy.lua`

## Key Keymaps

| Category | Key | Action |
|----------|-----|--------|
| General | `jk` | Exit insert mode |
| Save | `<leader>w` / `<leader>W` | Save / Save all |
| Quit | `<leader>q` / `<leader>Q` | Quit window / Quit Neovim |
| Buffers | `<Tab>` / `<S-Tab>` | Next/prev buffer |
| Splits | `<C-h/j/k/l>` | Navigate splits |
| Resize | `<C-Up/Down/Left/Right>` | Resize splits |
| Move lines | `<A-j>` / `<A-k>` | Move line/selection up/down |
| Indent | `<` / `>` (visual) | Indent keeping selection |
| Clipboard | `<leader>y` / `<leader>p` | System clipboard copy/paste |
| LSP | `gd` / `gD` / `gK` | Definition / Declaration / Signature help |
| Format | `<leader>cf` | Format with LSP |
| Toggles | `<leader>uf` | Toggle format on save |
| Toggles | `<leader>uH` | Toggle inlay hints |

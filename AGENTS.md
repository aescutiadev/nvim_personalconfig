# Neovim Config — AGENTS.md

## Architecture

- Neovim 0.12+ config, Lua, 2-space indent
- Entry: `init.lua` → loads `core.*` then `lsp`
- Load order: `options` → `keymaps` → `autocmds` → `diagnostics` → `lazy` (bootstraps plugins) → `lsp`
- Plugin specs: one file per plugin under `lua/plugins/<domain>/<name>.lua`, auto-imported via `lazy.lua`
- LSP servers: native `vim.lsp.enable()` (no nvim-lspconfig). Configs live in root `lsp/*.lua`
- Completion: blink.cmp with LSP, snippets, path, buffer, copilot sources
- UI: Snacks.nvim (pickers, git, zen, terminal, bigfile), Neo-tree, Tokyonight Moon, Catppuccin Mocha fallback
- Leader: `<Space>`, local leader: `\`

## Load order (init.lua)

1. `core.options` — vim.opt
2. `core.keymaps` — global keybindings
3. `core.autocmds` — bigfile, format-on-save, treesitter start, etc.
4. `core.diagnostics` — diagnostic config
5. `core.lazy` — bootstrap lazy.nvim, load plugins
6. `lsp` — capabilities, handlers, `vim.lsp.enable()` for all servers

## Adding a language

1. Create `lsp/<server_name>.lua` with `cmd`, `filetypes`, `root_markers`, `settings`
2. Add `vim.lsp.enable('<server_name>')` in `lua/lsp/init.lua`
3. Add Treesitter parser to `ensure_installed` in `lua/editor/treesitter.lua`
4. Optionally add `after/ftplugin/<filetype>.lua` for buffer-local settings

## Adding a plugin

Create `lua/plugins/<domain>/<name>.lua` returning a Lazy.nvim spec table. Domain subdirs: `ui/`, `editor/`, `lsp/`, `tools/`. Auto-discovered via `{ import = "plugins.<domain>" }` in `lua/core/lazy.lua`.

## Key gotchas

- `lua/lsp/init.lua`: `rust_analyzer` is commented out — enable with `vim.lsp.enable("rust_analyzer")`
- `lua/core/keymaps.lua`: `<leader>bb` is mapped twice (duplicate line 88, second overwrites first)
- `lua/plugins/ui/theme.lua`: exports `tokyonight` only — Catppuccin spec exists but is not returned
- `vim.g.format_on_save` defaults to `false` — toggle with `<leader>uf`
- Files >1MB: treesitter, LSP, syntax, folds, spell auto-disable (bigfile autocmd)
- CopilotChat reads `.github/copilot-instructions.md` and `AGENTS.md` as instruction files
- MCPHub servers: per-project `.mcphub/servers.json` or `:MCPHub` command
- `lua/lsp/handlers.lua` line 22-28: `<leader>l*` LSP keymaps reference `Snacks.picker` — must be available at LspAttach time (Snacks loads `lazy = false, priority = 1000`, so it's safe)
- Python: `basedpyright` LSP + Python 3.14.3 (`.python-version`)
- PHP: `intelephense` LSP + Laravel stack (`laravel.nvim`, `blade-nav`, `laravel-ide-helper.nvim`)
- `lua/plugins/tools/copilot.lua`: Copilot suggestions disabled — uses blink-cmp-copilot source instead

## Neovim 0.12 APIs used

- `vim.lsp.get_clients()` — not `vim.lsp.get_client_by_id()`
- `client:stop()` — not `vim.lsp.stop_client()`
- `vim.hl.on_yank()` — no compatibility shim
- `vim.diagnostic.config()` with `signs.text` — never `:sign-define`
- `vim.lsp.enable()` — native server activation, no lspconfig
- `pumborder = 'rounded'`, `completeopt` includes `nearest`
- Built-in LSP defaults: `grt`, `grx`, `gO`, `Ctrl-S`

## Verification

```bash
nvim --version          # Must be 0.12+
nvim --startuptime log  # Startup diagnostics
:checkhealth            # Verify LSP, treesitter, providers
:Lazy health            # Plugin health
```

Reset: `rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim && nvim`

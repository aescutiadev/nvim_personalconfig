# Personal Neovim Configuration

> A modern, modular Neovim configuration built for Neovim 0.11.6+ with native LSP, blink.cmp, and domain-based plugin organization.

## ✨ Features

- 🚀 **Modern Plugin Manager**: [Lazy.nvim](https://github.com/folke/lazy.nvim) for fast plugin loading
- 🎯 **Smart File Navigation**: [Snacks.nvim](https://github.com/folke/snacks.nvim) with fuzzy finder, live grep, git pickers
- 🔧 **Native LSP Support**: Neovim 0.11.6+ native LSP with `vim.lsp.enable()` — no nvim-lspconfig needed
- ⚡ **Completion Engine**: [blink.cmp](https://github.com/saghen/blink.cmp) with LSP, snippets, path, and buffer sources
- 🌳 **Syntax Highlighting**: [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) with native `vim.treesitter.start()`
- 🗂️ **File Explorer**: [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) with git integration and file operations
- 🔍 **Search & Replace**: [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) for project-wide find and replace
- 🎨 **Catppuccin Mocha**: Beautiful dark theme with LSP and Treesitter integration
- ⚡ **Quick Navigation**: [flash.nvim](https://github.com/folke/flash.nvim) for jumping anywhere
- 📝 **Git Integration**: [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) with inline blame and hunks
- 🔑 **Keymap Discovery**: [which-key.nvim](https://github.com/folke/which-key.nvim) with helix preset

### 🔤 Supported Languages

| Language | LSP Server | Features |
|----------|-----------|----------|
| **Lua** | `lua_ls` | Neovim-aware diagnostics, completions, formatting |
| **TypeScript/JavaScript** | `vtsls` | Inlay hints, refactoring, JSX/TSX support |
| **CSS/SCSS/Less** | `cssls` + `css_variables` | Validation, CSS variables resolution |
| **Tailwind CSS** | `tailwindcss` | Class completions, lint, multi-framework |
| **HTML** | `html` | Formatting, embedded languages |
| **Astro** | `astro` | Full Astro framework support |
| **Markdown** | `marksman` | Links, references, navigation |

## 🛠️ Installation

### Prerequisites

- **Neovim** >= 0.11.6
- **Git**
- **Node.js** >= 22.0 (for some LSP servers)
- A [Nerd Font](https://www.nerdfonts.com/) for icons

### Setup

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak

# Clone
git clone https://github.com/aescutiadev/nvim_personalconfig ~/.config/nvim

# Launch (plugins install automatically)
nvim
```

### Post-install

```vim
:Mason                    " Install LSP servers
:TSInstall lua typescript " Install Treesitter parsers
:checkhealth             " Verify everything works
```

## 🗂️ Project Structure

```
.
├── init.lua                    # Entry point
├── lazy-lock.json              # Plugin version lock
├── lsp/                        # Native LSP server configs (Neovim 0.11.6)
│   ├── lua_ls.lua
│   ├── vtsls.lua
│   ├── cssls.lua
│   ├── css_variables.lua
│   ├── tailwindcss.lua
│   ├── html.lua
│   ├── astro.lua
│   └── marksman.lua
├── after/ftplugin/             # Per-language buffer-local settings
│   ├── lua.lua
│   ├── astro.lua
│   └── markdown.lua
└── lua/
    ├── core/                   # Core configuration
    │   ├── options.lua         # vim.opt settings
    │   ├── keymaps.lua         # Global keybindings
    │   ├── autocmds.lua        # Auto-commands
    │   ├── diagnostics.lua     # Diagnostic config + keymaps
    │   └── lazy.lua            # Lazy.nvim bootstrap
    ├── lsp/                    # LSP logic modules
    │   ├── init.lua            # vim.lsp.enable() for all servers
    │   ├── capabilities.lua    # blink.cmp capabilities injection
    │   └── handlers.lua        # LspAttach: keymaps, document highlight
    ├── editor/                 # Editor logic modules
    │   ├── treesitter.lua      # Treesitter setup + ensure_installed
    │   ├── completion.lua      # Completion settings
    │   ├── folding.lua         # Fold enhancements
    │   └── formatting.lua      # Format commands
    └── plugins/                # Plugin specs (one file per plugin)
        ├── init.lua            # devicons, mini.icons
        ├── ui/
        │   ├── catppuccin.lua
        │   ├── neo-tree.lua
        │   ├── snacks.lua
        │   ├── which-key.lua
        │   └── lualine.lua
        ├── editor/
        │   ├── treesitter.lua
        │   ├── blink.lua
        │   ├── gitsigns.lua
        │   ├── flash.lua
        │   ├── pairs.lua
        │   ├── matchup.lua
        │   ├── template-string.lua
        │   ├── todo-comments.lua
        │   └── colorizer.lua
        ├── lsp/
        │   └── mason.lua
        └── tools/
            ├── grug-far.lua
            ├── schemastore.lua
            ├── package-info.lua
            └── tsc.lua
```

## ⌨️ Key Mappings

**Leader**: `<Space>` · **Local leader**: `,`

### General

| Key | Action |
|-----|--------|
| `jk` | Exit insert mode |
| `<leader>w` | Save file |
| `<leader>q` | Quit window |
| `<Esc>` | Clear search highlights |

### Navigation (Snacks)

| Key | Action |
|-----|--------|
| `,` | Find files |
| `<leader>/` | Live grep |
| `<leader>,` | Buffer switcher |
| `<leader>fs` | Smart find files |
| `<leader>fg` | Git files |
| `<leader>fr` | Recent files |
| `<leader>fp` | Projects |

### File Explorer (Neo-tree)

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `<leader><space>` | Float file explorer |
| `<leader>o` | Focus Neo-tree |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | References |
| `gI` | Implementations |
| `gy` | Type definition |
| `K` | Hover documentation |
| `grn` | Rename (built-in) |
| `gra` | Code action (built-in) |
| `<leader>cd` | Show diagnostic float |
| `<leader>cf` | Format with LSP |
| `<leader>th` | Toggle inlay hints |

### Git

| Key | Action |
|-----|--------|
| `<leader>gg` | Lazygit |
| `<leader>gs` | Git status |
| `<leader>gl` | Git log |
| `<leader>ghp` | Preview hunk |
| `<leader>ghb` | Blame line |
| `]c` / `[c` | Next/prev git change |

### Search & Replace

| Key | Action |
|-----|--------|
| `<leader>rs` | Search/replace workspace |
| `<leader>rw` | Replace current word |
| `<leader>rf` | Search/replace in file |
| `s` / `S` | Flash jump / Treesitter |

### Diagnostics

| Key | Action |
|-----|--------|
| `<leader>cd` | Diagnostic float (inline) |
| `<leader>sd` | All diagnostics (picker) |
| `<leader>sD` | Buffer diagnostics |
| `]d` / `[d` | Next/prev diagnostic |
| `<leader>ud` | Toggle diagnostics |

### UI Toggles

| Key | Action |
|-----|--------|
| `<leader>z` | Zen mode |
| `<leader>uh` | Toggle inlay hints |
| `<leader>ud` | Toggle diagnostics |
| `<leader>ul` | Toggle line numbers |
| `<leader>uw` | Toggle word wrap |
| `<leader>us` | Toggle spell check |

## 🔧 Customization

### Adding a New Language

1. Create `lsp/<server_name>.lua` at the config root:
   ```lua
   ---@type vim.lsp.Config
   return {
     cmd = { 'server-binary', '--stdio' },
     filetypes = { 'your_language' },
     root_markers = { 'config.json', '.git' },
     settings = {},
   }
   ```

2. Enable it in `lua/lsp/init.lua`:
   ```lua
   vim.lsp.enable('server_name')
   ```

3. Add Treesitter parser to `ensure_installed` in `lua/editor/treesitter.lua`

4. Optionally create `after/ftplugin/<filetype>.lua` for buffer-local settings

### Adding a New Plugin

Create a file in the appropriate domain subdirectory:

```lua
-- lua/plugins/editor/my-plugin.lua
return {
  "author/my-plugin.nvim",
  event = "VeryLazy",
  opts = {},
}
```

It's auto-discovered by Lazy.nvim via `{ import = "plugins.editor" }`.

## 🐛 Troubleshooting

| Issue | Command |
|-------|---------|
| LSP not starting | `:LspInfo` / `:checkhealth lsp` |
| Plugins not loading | `:Lazy health` / `:Lazy restore` |
| Treesitter errors | `:TSUpdate` |
| Plugin load times | `:Lazy profile` |
| Startup time | `nvim --startuptime startup.log` |

### Reset

```bash
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
nvim  # Reinstalls everything
```

## 📝 License

MIT License. See [LICENSE](LICENSE) for details.

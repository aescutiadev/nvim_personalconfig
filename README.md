# Personal Neovim Configuration

> A modern, modular Neovim configuration built for Neovim 0.11+ with native LSP, advanced UI, and multi-cursor editing.

## ✨ Features

- 🚀 **Modern Plugin Manager**: [Lazy.nvim](https://github.com/folke/lazy.nvim) for fast plugin loading
- 🎯 **Smart File Navigation**: [Snacks.nvim](https://github.com/folke/snacks.nvim) with fuzzy finder and live grep
- 🔧 **Native LSP Support**: Neovim 0.11+ native LSP with `vim.lsp.enable()` and semantic tokens
- 🌳 **Syntax Highlighting**: [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) with enhanced parsing
- 🎭 **Multi-cursor Editing**: [multiple-cursors.nvim](https://github.com/brenton-leighton/multiple-cursors.nvim) with visual mode support
- 📑 **Buffer Management**: [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) with custom styling
- 🗂️ **File Explorer**: [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) with git integration
- 🔍 **Search & Replace**: [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) for project-wide find and replace
- 🎨 **Modern UI**: Mini.icons, Lualine, and custom highlights
- 🤖 **AI Integration**: GitHub Copilot with chat interface
- ⚡ **Quick Navigation**: [flash.nvim](https://github.com/folke/flash.nvim) for jumping anywhere
- 📝 **Git Integration**: [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) with inline blame and hunks

### 🔤 Supported Languages

- **Lua** - lua_ls with native LSP configuration
- **Astro** - astro LSP for Astro framework
- **Markdown** - marksman and mdx_analyzer for Markdown/MDX
- **HTML** - html LSP for HTML files
- Additional languages can be easily added via `lua/config/lsp.lua`

## 🛠️ Installation

### Prerequisites

Ensure you have the following installed:

- **Neovim** >= 0.11.5 (required for native LSP features)
- **Git**
- **Node.js** >= 22.0 (for treesitter and some LSP servers)
- **pnpm** (package manager, managed via packageManager field)

### Step 1: Backup Current Configuration

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

### Step 2: Clone This Configuration

```bash
git clone https://github.com/aescutiadev/nvim_personalconfig ~/.config/nvim
cd ~/.config/nvim
```

### Step 3: Start Neovim

```bash
nvim
```

On first launch, Lazy.nvim will automatically install all plugins.

### Step 4: Verify Installation

Run health checks to ensure everything is working correctly:

```vim
:checkhealth lazy
:checkhealth nvim-treesitter
:checkhealth lsp
```

Check LSP status:

```vim
:LspInfo
```

## 🎯 Key Features

### 🔧 Native LSP Configuration (Neovim 0.11+)

- **Native LSP** using `vim.lsp.enable()` for automatic server activation
- **Enhanced capabilities** with semantic tokens and multiline token support
- **Inlay hints** enabled automatically (disabled for lua, markdown, toml, and help files)
- **Completion support** with snippet and documentation formatting
- **LSP handlers** configured in `lua/config/lsp.lua`

### 🎨 UI Enhancements

- **Bufferline** with custom styling and buffer management
- **Mini.icons** for file type icons throughout the UI
- **Lualine** status line with custom sections
- **Neo-tree** file explorer with git integration
- **Grug-far** for powerful project-wide search and replace
- **Flash** for quick navigation and search

### 🖱️ Multi-cursor Editing

Advanced multi-cursor capabilities:

- `<C-Down>` / `<C-j>` - Add cursor and move down
- `<C-Up>` / `<C-k>` - Add cursor and move up
- `<C-LeftMouse>` - Add cursor at mouse position (normal mode)
- `<S-LeftMouse>` - Add cursor with selection (insert mode)
- Visual mode: Select then use `<C-j>` / `<C-k>` for multiple cursors

### 🗂️ Project Structure

```text
.
├── init.lua                  # Entry point - loads all config modules
├── lazy-lock.json            # Plugin version lock file
├── package.json              # Package manager configuration (pnpm)
├── LICENSE                   # MIT License
├── README.md                 # This file
└── lua/
    ├── config/               # Core Neovim configuration
    │   ├── autocmds.lua      # Auto-commands and event handlers
    │   ├── keymaps.lua       # Global keybindings
    │   ├── lazy.lua          # Lazy.nvim plugin manager setup
    │   ├── lsp.lua           # Native LSP configuration (0.11+)
    │   └── options.lua       # Neovim options and settings
    └── plugins/              # Plugin configurations
        ├── bufferline.lua    # Buffer tabline
        ├── copilot/          # GitHub Copilot integration
        │   └── init.lua
        ├── flash.lua         # Quick navigation
        ├── gitsigns.lua      # Git integration
        ├── grug-far.lua      # Search and replace
        ├── json/             # JSON language support
        │   └── init.lua
        ├── lspkind.lua       # LSP kind icons
        ├── lualine.lua       # Status line
        ├── markdown-render.lua # Markdown rendering
        ├── mini.lua          # Mini.icons for file icons
        ├── multicursor.lua   # Multiple cursors
        ├── neo-tree.lua      # File explorer
        ├── snacks.lua        # File picker and utilities
        ├── treesitter.lua    # Syntax highlighting
        ├── ts-utils.lua      # TypeScript utilities
        └── whichkey.lua      # Key binding helper
```

### ⌨️ Key Mappings

**Leader key**: `<Space>`  
**Local leader key**: `,`

#### General

- `<leader>w` - Save file
- `<leader>W` - Save all buffers
- `<leader>q` - Quit window
- `<leader>Q` - Quit Neovim
- `<leader>nc` - Clear search highlights
- `jk` (insert mode) - Exit to normal mode
- `<Esc>` - Clear search highlights

#### Window Management

- `<leader>sv` - Split window vertically
- `<leader>sh` - Split window horizontally
- `<leader>se` - Equalize window sizes
- `<leader>sx` - Close current window
- `<C-h/j/k/l>` - Navigate between windows

#### Clipboard Operations

- `<leader>y` - Copy to system clipboard (normal/visual)
- `<leader>Y` - Copy line to system clipboard
- `<leader>p` - Paste from system clipboard

#### Navigation (Snacks)

- `<leader><space>` - Smart file finder
- `<leader>,` - Buffer switcher
- `<leader>/` - Live grep in project
- `<leader>e` - Toggle file explorer (Neo-tree)
- `<leader>sg` - Git files
- `<leader>sG` - Git status

#### Buffer Management (Bufferline)

Configured via `lua/plugins/bufferline.lua` with mouse support and custom styling.

#### LSP (Native 0.11+)

LSP keymaps are configured in `lua/config/lsp.lua` and attach automatically when LSP starts.

#### Multi-cursor Operations

- `<C-Down>` / `<C-j>` - Add cursor and move down (normal mode)
- `<C-Up>` / `<C-k>` - Add cursor and move up (normal mode)
- `<C-LeftMouse>` - Add cursor at mouse position (normal mode)
- `<S-LeftMouse>` - Add cursor at mouse with selection (insert mode)
- Visual mode: Select text then use `<C-j>` / `<C-k>` for multiple cursors

#### Git Integration (Gitsigns)

Configured in `lua/plugins/gitsigns.lua` with stage, reset, and blame features.

#### Search & Replace (Grug-far)

Configured in `lua/plugins/grug-far.lua` for project-wide operations.

## 🔧 Customization

### Adding a New Language

This configuration uses Neovim 0.11+ native LSP. To add a new language:

1. **Enable the LSP server** in `lua/config/lsp.lua`:
   ```lua
   vim.lsp.enable('your_language_server')
   ```

2. **Add Treesitter parser** in `lua/plugins/treesitter.lua`:
   ```lua
   ensure_installed = {
     -- existing parsers...
     "your_language",
   }
   ```

3. **Create language-specific plugin** (optional):
   Create `lua/plugins/your_language/init.lua` for additional tooling:
   ```lua
   return {
     {
       "nvim-treesitter/nvim-treesitter",
       opts = function(_, opts)
         vim.list_extend(opts.ensure_installed, { "your_language" })
         return opts
       end,
     },
   }
   ```

### Customizing LSP Behavior

Edit `lua/config/lsp.lua` to modify:

- **Global LSP settings**: Modify the `vim.lsp.config('*', {...})` block
- **LSP capabilities**: Extend the capabilities table with additional features
- **Inlay hints**: Add/remove filetypes from `INLAY_HINTS_DISABLED_FT`
- **Server-specific settings**: Use `vim.lsp.config('server_name', {...})` for individual servers

### Customizing UI Elements

- **Bufferline**: Edit `lua/plugins/bufferline.lua` for tab styling
- **Status line**: Edit `lua/plugins/lualine.lua` for status bar customization
- **File icons**: Edit `lua/plugins/mini.lua` for icon configuration
- **File explorer**: Edit `lua/plugins/neo-tree.lua` for tree view settings
- **Keymaps**: Edit `lua/config/keymaps.lua` for custom key bindings
- **Options**: Edit `lua/config/options.lua` for Neovim settings

## 🐛 Troubleshooting

### Common Issues

1. **LSP not starting**: 
   ```vim
   :LspInfo
   ```
   Check if the server is enabled in `lua/config/lsp.lua`

2. **Plugins not loading**: 
   ```vim
   :Lazy health
   :Lazy restore
   ```

3. **Treesitter errors**: 
   ```vim
   :TSUpdate
   :TSUpdateSync
   ```

4. **Git integration issues**:
   ```vim
   :checkhealth gitsigns
   ```

5. **Neovim version**: This config requires Neovim 0.11.5+
   ```bash
   nvim --version
   ```

### Reset Configuration

If something goes wrong, you can reset everything:

```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
nvim  # Will reinstall all plugins
```

### Performance Tips

- Check plugin load times: `:Lazy profile`
- Disable inlay hints: `:lua vim.lsp.inlay_hint.enable(false)`
- Update Treesitter parsers: `:TSUpdate all`
- Check startup time: `nvim --startuptime startup.log`

## 📚 Resources

- [Neovim 0.11 Documentation](https://neovim.io/doc/user/lsp.html) - Native LSP features
- [Lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [Neovim Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax highlighting
- [Snacks.nvim](https://github.com/folke/snacks.nvim) - Collection of utilities
- [Multiple Cursors](https://github.com/brenton-leighton/multiple-cursors.nvim) - Multi-cursor editing

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/aescutiadev/nvim_personalconfig/issues).

## 📝 License

This configuration is available under the MIT License. See [LICENSE](LICENSE) file for details.

---

**Note**: This configuration is optimized for Neovim 0.11+ and uses native LSP features with `vim.lsp.enable()`. For older Neovim versions, consider using nvim-lspconfig instead.

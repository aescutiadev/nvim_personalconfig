# Personal Neovim Configuration

> A modern, modular Neovim configuration with LSP, formatters, linters, and more.

## ✨ Features

- 🚀 **Modern Plugin Manager**: [Lazy.nvim](https://github.com/folke/lazy.nvim)
- 🎯 **File Picker**: [Snacks.nvim](https://github.com/folke/snacks.nvim) (replaces Telescope)
- 🧠 **Completion**: [Blink.cmp](https://github.com/saghen/blink.cmp)
- 🔧 **LSP Support**: Multi-language LSP with auto-installation
- 🎨 **Formatting**: [conform.nvim](https://github.com/stevearc/conform.nvim) with auto-format on save
- 🔍 **Linting**: [nvim-lint](https://github.com/mfussenegger/nvim-lint) with real-time feedback
- 🌳 **Syntax Highlighting**: [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- 📦 **Package Management**: [Mason.nvim](https://github.com/williamboman/mason.nvim)

### 🔤 Supported Languages

- **Lua** - lua_ls, stylua, luacheck
- **Python** - pyright, black, isort, flake8, mypy
- **JavaScript** - vtsls, prettier, eslint_d
- **TypeScript** - vtsls, prettier, eslint_d
- **Vue** - volar, prettier, eslint_d
- **Astro** - astro, prettier, eslint_d

## 🛠️ Installation

### Prerequisites

Ensure you have the following installed:

- **Neovim** >= 0.10.0
- **Git**
- **Node.js** >= 18.0 (for LSP servers and tools)
- **Python** >= 3.8 (for Python support)

### Step 1: Backup Current Configuration

```shell
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

### Step 2: Clone This Configuration

```shell
git clone https://github.com/aescutiadev/nvim_personalconfig ~/.config/nvim
```

### Step 3: Install Required Dependencies

#### Node.js Tools

```shell
# Install pnpm (if not already installed)
npm install -g pnpm

# Install Node.js provider for Neovim
pnpm install -g neovim

# Install tree-sitter CLI (required for some parsers)
pnpm install -g tree-sitter-cli
```

#### Python Tools

```shell
# Install Python provider for Neovim
pipx install pynvim

# Alternative if pipx is not available:
# python3 -m pip install --user neovim --break-system-packages
```

### Step 4: Start Neovim

```shell
nvim
```

On first launch, Lazy.nvim will automatically:

- Install all plugins
- Download LSP servers, formatters, and linters via Mason
- Configure everything according to your setup

### Step 5: Verify Installation

Run health checks to ensure everything is working correctly:

```vim
:checkhealth
```

Specifically check:

```vim
:checkhealth lazy
:checkhealth mason
:checkhealth nvim-treesitter
:checkhealth lsp
:checkhealth provider
```

## 🎯 Key Features

### 🔧 LSP Configuration

- **Global LSP settings** with consistent keymaps
- **Language-specific configurations** in modular files
- **Auto-installation** of LSP servers via Mason

### 🗂️ Modular Structure

```text
lua/
├── config/           # Core Neovim configuration
│   ├── autocmds.lua
│   ├── keymaps.lua
│   ├── lazy.lua
│   └── options.lua
└── plugins/
    ├── core/         # Essential plugins
    │   ├── langs/    # Language-specific configs
    │   │   ├── lua/
    │   │   ├── python/
    │   │   ├── javascript/
    │   │   └── typescript/
    │   ├── blink.lua
    │   ├── formatting.lua
    │   ├── init.lua
    │   ├── linting.lua
    │   ├── lsp.lua
    │   └── treesitter.lua
    └── ui/           # UI enhancements
        ├── autopairs.lua
        ├── flash.lua
        └── whichkey.lua
```

### ⌨️ Key Mappings

#### Global Navigation (Snacks)

- `<leader><space>` - Smart file finder
- `<leader>,` - Buffer switcher
- `<leader>/` - Live grep
- `<leader>e` - File explorer

#### LSP (Buffer-local)

- `gd` - Go to definition
- `gr` - Find references
- `K` - Hover documentation
- `grn` - Rename symbol
- `gra` - Code actions

#### General

- `<leader>w` - Save file
- `<leader>q` - Quit
- `<leader>nc` - Clear search highlights
- `jk` (insert mode) - Exit to normal mode

#### Language-specific

- `<leader>l*` - Lua commands
- `<leader>p*` - Python commands
- `<leader>j*` - JavaScript commands
- `<leader>t*` - TypeScript/Vue/Astro commands

## 🔧 Customization

### Adding a New Language

1. Create a new file: `lua/plugins/core/langs/[language]/init.lua`
2. Follow the existing pattern:
   - Extend treesitter parsers
   - Configure LSP server
   - Add formatters and linters
   - Set up Mason tools

Example structure:

```lua
return {
  -- Extend Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "your_language" })
      return opts
    end,
  },
  
  -- Add LSP
  {
    "neovim/nvim-lspconfig", 
    opts = function(_, opts)
      opts.servers.your_lsp = { --[[ config ]] }
      return opts
    end,
  },
  
  -- Add formatters/linters...
}
```

## 🐛 Troubleshooting

### Common Issues

1. **Providers not working**: Run `:checkhealth provider`
2. **LSP not starting**: Run `:LspInfo` and `:Mason`
3. **Plugins not loading**: Run `:Lazy health`
4. **Tree-sitter errors**: Ensure `tree-sitter-cli` is installed

### Reset Configuration

If something goes wrong, you can reset:

```shell
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim  
rm -rf ~/.cache/nvim
nvim  # Will reinstall everything
```

## 📚 Learning Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [Lazy.nvim Guide](https://lazy.folke.io/)
- [LSP Configuration](https://github.com/neovim/nvim-lspconfig)
- [Mason.nvim](https://github.com/williamboman/mason.nvim)

## 🤝 Contributing

Feel free to submit issues and pull requests to improve this configuration!

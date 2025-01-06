# Neovim Configuration

My modern Neovim setup focused on development with LSP support, fuzzy finding, and code completion.

**_NOTE:_** This configuration is highly inspired by the [kickstart](https://github.com/nvim-lua/kickstart.nvim) project.

## Core Features

- Plugin management with lazy.nvim
- LSP support with auto-installation of language servers
- Fuzzy finding with Telescope
- Code completion with nvim-cmp
- Syntax highlighting with Treesitter
- Auto-formatting with conform.nvim
- Git integration
- Minimal statusline

## Directory Structure

```
~/.config/nvim/
├── init.lua                 # Main configuration entry point
├── .stylua.toml            # Lua formatting rules (column width, indents)
├── .gitignore              # Git ignore patterns
└── lua/
    └── custom/            # Personal configuration files
        ├── autocmds.lua   # Automatic commands (yank highlight, etc.)
        ├── keymaps.lua    # Key mappings (navigation, LSP, etc.)
        ├── options.lua    # Neovim options (numbers, tabs, etc.)
        └── plugins/       # Plugin configurations
            ├── init.lua          # Plugin declarations and simple setups
            ├── telescope.lua     # Fuzzy finder and pickers
            ├── lsp.lua          # Language server configs
            ├── completion.lua    # Code completion behavior
            ├── treesitter.lua   # Syntax highlighting settings
            ├── mini.lua         # Mini plugin collection setup
            ├── colorscheme.lua  # Theme configuration
            └── conform.lua      # Code formatting rules
```

## Key Mappings

Leader key: `Space`

### Navigation
- `<C-h/j/k/l>` - Window navigation
- `<C-d>/<C-u>` - Scroll down/up (centered)

### Telescope
- `<leader>sf` - Find files
- `<leader>sg` - Live grep
- `<leader>sw` - Search current word
- `<leader>/` - Search in current buffer
- `<leader>s.` - Recent files

### LSP
- `gd` - Go to definition
- `gr` - Show references
- `K` - Show documentation
- `<leader>rn` - Rename
- `<leader>ca` - Code actions
- `[d/]d` - Previous/next diagnostic

### Editor
- `<leader>f` - Format buffer
- `<Esc>` - Clear search highlight
- `<leader>e` - Show diagnostic float

## LSP Servers

Automatically installs and configures:
- lua_ls for Lua
- pyright for Python
- clangd for C/C++
- rust-analyzer for Rust
- eslint for JavaScript/TypeScript

Additional servers can be installed via `:Mason`

## Notes

- Format on save disabled for all filetypes
- Treesitter auto-installs syntax support for commonly used languages
- Custom statusline using mini.nvim
- Fuzzy finding respects .gitignore

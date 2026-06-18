# My Neovim config

This is my personal Neovim setup — a Lua config built on [lazy.nvim](https://github.com/folke/lazy.nvim) and tuned for everyday development: LSP, fuzzy finding, completion, git integration, and a handful of quality-of-life plugins. It started from the [kickstart](https://github.com/nvim-lua/kickstart.nvim) project and has drifted in its own direction since.

The leader key is `<Space>`.

## What's in here

- **lazy.nvim** for plugin management — it bootstraps itself on the first launch
- **LSP** via `nvim-lspconfig` and `mason`, with servers installed automatically. Right now that's `rust_analyzer`, `clangd`, and `lua_ls`
- **Completion** through `nvim-cmp` and `LuaSnip` (Copilot is disabled on purpose)
- **Telescope** for fuzzy finding files, grep, and symbols
- **Treesitter** for syntax highlighting (js/ts, go, c, lua, svelte, markdown)
- **conform.nvim** for format-on-save (stylua, prettier with eslint, gofumpt)
- **Harpoon** for jumping between the files I work in most
- **Oil** for editing the filesystem like a regular buffer
- **Gitsigns** and inline git blame
- A few **mini.nvim** modules, commenting, tmux navigation, and a DAP setup for debugging
- The **catppuccin** theme with a transparent background

## Layout

```
~/.config/nvim/
├── init.lua              # entry point
├── lua/
│   ├── opts.lua          # editor options
│   ├── keymaps.lua       # general keymaps
│   ├── servers.lua       # LSP server definitions
│   ├── utils.lua         # small helpers
│   ├── config/
│   │   └── lazy.lua      # lazy.nvim bootstrap and setup
│   └── plugins/          # one file per plugin (lsp, completions, telescope, ...)
└── lazy-lock.json        # pinned plugin versions
```

## Getting started

Clone it into your config directory and open Neovim — lazy.nvim installs everything on the first run:

```sh
git clone https://github.com/MaxwellKnight/nvim-config.git ~/.config/nvim
nvim
```

After that, run `:checkhealth` to spot anything missing. Some servers and formatters expect their CLI tools to be on your `PATH`.

## Handy keymaps

- `<C-Space>` — open the completion menu
- `gd` / `gr` — go to definition / find references
- `<leader>ca` — code action
- `<leader>rn` — rename symbol
- `<leader>cf` — copy the current file's absolute path to the clipboard

## Adding a language server

Add an entry to `lua/servers.lua`, keyed by the lspconfig server name, and mason installs it for you. Completion and keymaps get wired up automatically.

# My Neovim config

Hey 👋 — this is my personal Neovim setup. It's a Lua config built on [lazy.nvim](https://github.com/folke/lazy.nvim), tuned for day-to-day dev work: LSP, fuzzy finding, completion, git, the usual good stuff. Originally riffed off the [kickstart](https://github.com/nvim-lua/kickstart.nvim) idea, then taken in my own direction.

Leader key is `<Space>`.

## What's in here

- **lazy.nvim** for plugins — bootstraps itself on first launch, so you don't have to
- **LSP** via `nvim-lspconfig` + `mason` (servers auto-install). Currently wired up for `rust_analyzer`, `clangd`, and `lua_ls`
- **Completion** with `nvim-cmp` + `LuaSnip` (no Copilot — it's intentionally disabled)
- **Telescope** for fuzzy finding files, grep, symbols, the works
- **Treesitter** for syntax highlighting (js/ts, go, c, lua, svelte, markdown)
- **conform.nvim** for format-on-save (stylua, prettier + eslint, gofumpt)
- **Harpoon** for jumping between the files you actually care about
- **Oil** for editing the filesystem like a buffer
- **Gitsigns** + git blame for git stuff inline
- **mini.nvim** bits, comments, tmux navigation, and a DAP setup for debugging
- **catppuccin** theme with a transparent background

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
│   │   └── lazy.lua      # lazy.nvim bootstrap + setup
│   └── plugins/          # one file per plugin (lsp, completions, telescope, ...)
└── lazy-lock.json        # pinned plugin versions
```

## Getting started

Clone it into your config spot and open Neovim — lazy.nvim grabs everything on the first run:

```sh
git clone https://github.com/MaxwellKnight/nvim-config.git ~/.config/nvim
nvim
```

Then run `:checkhealth` to see if anything's missing (some servers/formatters want their CLIs on your `PATH`).

## A few handy keys

- `<C-Space>` — force the completion menu open
- `gd` / `gr` — go to definition / find references
- `<leader>ca` — code action
- `<leader>rn` — rename symbol
- `<leader>cf` — copy the current file's absolute path to the clipboard

## Adding a language server

Drop a new entry in `lua/servers.lua` (key = the lspconfig server name) and mason takes care of installing it. That's it — completion and keymaps get hooked up automatically.

Steal whatever's useful. 🙂

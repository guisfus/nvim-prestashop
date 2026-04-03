# Neovim Configuration for Laravel + Vue

A modular **Neovim `0.12+`** configuration built around native Neovim features.

It is optimized for a **Laravel + Vue + Inertia** workflow, while staying clean enough to reuse as a general web-development setup.

![Neovim config screenshot](.github/assets/screenshot.png)

## Why this config

This repository is meant to be a practical middle ground between a fully personal dotfiles setup and a heavy Neovim distribution.

It focuses on:

- keeping the config small and understandable
- preferring native Neovim features when they are good enough
- using `vim.pack` instead of a third-party plugin manager
- separating plugin declaration, plugin setup, and LSP configuration clearly
- staying useful for Laravel, Vue, TypeScript, Lua, Markdown, and everyday editing
- degrading gracefully when optional external tools are missing

## Who this is for

This repo is a good fit if you want:

- a personal Neovim config that is still clean enough to publish and maintain
- built-in LSP with explicit per-server files
- Treesitter, completion, formatting, diagnostics, file explorer, and fuzzy search
- a practical base for web development, especially Laravel + Vue
- a setup that stays readable and easy to extend

## What works out of the box

This configuration includes:

- **LSP support** with one file per server under `after/lsp/`
- **Treesitter** for syntax highlighting and parser-based editing features
- **Autocompletion** with `nvim-cmp` + `LuaSnip`
- **Formatting** through `conform.nvim`
- **Diagnostics UI** with `trouble.nvim`
- **File explorer** with `nvim-tree`
- **Buffer/tab line** with `bufferline.nvim`
- **Fuzzy finding** through `fzf-lua`

### Main language workflow

- **Laravel / PHP**: `intelephense` + `pint`
- **Vue**: `vue_ls` + `ts_ls` + `@vue/typescript-plugin`
- **TypeScript / JavaScript**: TypeScript LSP + Prettier + optional ESLint diagnostics
- **Lua**: `lua_ls` + `stylua`
- **Markdown**: `marksman`
- **Blade**: custom filetype detection plus Treesitter parser support

## Quick start

Clone the repo into your Neovim config directory:

```bash
git clone https://github.com/guisfus/nvim-laravel-vue.git ~/.config/nvim
```

Open Neovim once so `vim.pack` can install plugins.

Then update plugins and parsers:

```vim
:lua vim.pack.update()
:TSUpdate
```

After `:lua vim.pack.update()`, Neovim opens a confirmation buffer in a separate tab showing the pending plugin changes.

To actually apply those updates, run:

```vim
:write
```

If you do not confirm with `:write`, the updates are not applied.  
To discard them, use:

```vim
:quit
```

After applying plugin updates, you can optionally run `:restart` to start using the updated plugin code.

## Requirements

These are the baseline requirements:

- **Neovim 0.12+**
- `git`
- a **Nerd Font**

## Recommended CLI tools

These tools are not strictly required for Neovim to start, but they improve the experience a lot:

- `fzf`
- `ripgrep`
- `fd` or `fdfind`

The config is meant to degrade gracefully when some optional tools are missing, but features like fuzzy finding, search, and some language tooling work best when these are installed.

## Clipboard provider

This config enables `clipboard=unnamedplus`.

Install a clipboard provider depending on your OS:

- **Linux**: `xclip`, `xsel`, or `wl-clipboard`
- **macOS**: `pbcopy` is usually available by default
- **Windows**: a working provider such as `win32yank`

## Language servers and formatters

### LSPs / language tools

- `lua-language-server`
- `intelephense`
- `typescript`
- `typescript-language-server`
- `@vue/language-server`
- `vscode-langservers-extracted`
- `vscode-eslint-language-server`
- `@tailwindcss/language-server`
- `marksman`

### Formatters

- `prettier`
- `stylua`
- `vendor/bin/pint` for Laravel projects

## Suggested installs

### JavaScript / Vue tooling

```bash
npm install -g \
  typescript \
  typescript-language-server \
  @vue/language-server \
  vscode-langservers-extracted \
  vscode-eslint-language-server \
  @tailwindcss/language-server \
  prettier
```

### Lua tooling

```bash
cargo install stylua
```

## Notes by stack

### Vue

Vue support depends on:

- `vue_ls`
- `ts_ls`
- `@vue/typescript-plugin`

The config first tries to resolve Vue tooling from the project tree and then falls back to the global npm installation.

If a required binary is missing, that server is skipped instead of hard-failing at startup.

### Laravel / PHP

PHP formatting uses `pint`, preferably from the Laravel project itself:

- `vendor/bin/pint`

### Blade

Blade support depends on:

- custom filetype detection
- Treesitter parser support

This repo currently **does not ship custom Blade queries**.

If you want richer Blade highlighting than the upstream parser provides, add them under:

```text
queries/blade/
```

## Common first-run commands

These are the most useful commands after cloning the repo:

```vim
:lua vim.pack.update()
:TSUpdate
:checkhealth
```

A good first check is:

- run `:lua vim.pack.update()` if plugins are missing
- confirm plugin updates with `:write` in the `vim.pack.update()` confirmation buffer
- run `:TSUpdate` if Treesitter features are incomplete
- run `:checkhealth` if clipboard, providers, or tooling behave unexpectedly

## Daily usage

A few common actions should cover most of the workflow:

- browse files with the file explorer
- jump between files and symbols with fuzzy finding
- inspect problems through diagnostics and Trouble
- format files with the configured formatter pipeline
- rely on LSP features such as go-to-definition, references, rename, and hover

If you want to customize the editing experience first, the most useful places to look at are:

- `lua/config/keymaps.lua`
- `lua/config/options.lua`
- `lua/config/autocmds.lua`

If you want to extend language support, check:

- `after/lsp/`
- `lua/config/conform.lua`
- `lua/config/treesitter.lua`

## Repository layout

```text
~/.config/nvim/
├── .github/
│   └── assets/
│       └── screenshot.png
├── after/
│   ├── lsp/
│   └── plugin/
│       └── setup.lua
├── docs/
│   └── architecture.md
├── lua/
│   ├── config/
│   │   ├── autocmds.lua
│   │   ├── bufferline.lua
│   │   ├── cmp.lua
│   │   ├── conform.lua
│   │   ├── filetypes.lua
│   │   ├── keymaps.lua
│   │   ├── nvimtree.lua
│   │   ├── options.lua
│   │   ├── treesitter.lua
│   │   └── trouble.lua
│   └── plugins.lua
├── init.lua
└── nvim-pack-lock.json
```

### Structure at a glance

- `init.lua` → entry point and load coordination
- `lua/plugins.lua` → plugin declaration
- `after/plugin/setup.lua` → plugin setup after plugins are available
- `lua/config/*` → modular editor and plugin configuration
- `after/lsp/*` → one file per LSP server
- `docs/architecture.md` → internal design notes and extension guide
- `.github/assets/` → repository presentation assets such as the README screenshot

If you want to understand how the config is organized or extend it safely, read [`docs/architecture.md`](docs/architecture.md).

## Philosophy behind the structure

The config follows a simple rule:

- one responsibility per file
- clear separation between plugin installation and plugin setup
- explicit LSP files instead of a large monolithic config
- simple structure over clever abstractions

That makes it easier to:

- debug
- extend
- remove pieces you do not want
- keep the repo understandable over time

## What is configurable

Most day-to-day changes should have an obvious place:

- general editor behavior → `lua/config/options.lua`
- global keymaps → `lua/config/keymaps.lua`
- automations → `lua/config/autocmds.lua`
- custom filetypes → `lua/config/filetypes.lua`
- formatters → `lua/config/conform.lua`
- Treesitter setup → `lua/config/treesitter.lua`
- completion → `lua/config/cmp.lua`
- file explorer → `lua/config/nvimtree.lua`
- diagnostics UI → `lua/config/trouble.lua`
- LSP-specific setup → `after/lsp/*.lua`

## Known limitations

A few things are intentionally simple right now:

- Blade highlighting is limited by the upstream parser unless you add custom queries
- some features depend on external binaries installed outside Neovim
- Vue support is best when both the project-local and global toolchain are in a healthy state

## Troubleshooting

### Plugins did not install

Open Neovim and run:

```vim
:lua vim.pack.update()
```

Then confirm the pending updates in the confirmation buffer with:

```vim
:write
```

If you close that buffer without `:write`, the updates are not applied.

### Treesitter features are missing

Run:

```vim
:TSUpdate
```

### Clipboard is not working

Make sure you have a clipboard provider installed for your OS.

### Vue or TypeScript support is incomplete

Check that these are available:

- `typescript-language-server`
- `@vue/language-server`
- `@vue/typescript-plugin`

### PHP formatting does not work

Make sure your Laravel project has:

```text
vendor/bin/pint
```

## Why this over a full distro?

This repo is for people who want a setup that feels curated, but still readable.

Compared with heavier Neovim distributions, the goal here is:

- less abstraction
- less hidden behavior
- clearer file ownership
- easier Laravel + Vue customization
- native Neovim-first decisions where possible

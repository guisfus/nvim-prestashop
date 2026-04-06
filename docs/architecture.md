# Neovim Configuration Architecture

This document describes the structure of the **PrestaShop-focused** Neovim configuration in this repository.

## Design rules

- keep one responsibility per file
- keep plugin declaration separate from plugin setup
- keep editor behavior in `lua/config/`
- keep LSP servers split into `after/lsp/`
- prefer small, explicit configuration over abstractions

## Structure

```text
~/.config/nvim/
├── init.lua
├── lua/
│   ├── plugins.lua
│   └── config/
│       ├── autocmds.lua
│       ├── bufferline.lua
│       ├── cmp.lua
│       ├── conform.lua
│       ├── filetypes.lua
│       ├── keymaps.lua
│       ├── lsp/
│       │   └── twiggy_language_server.lua
│       ├── nvimtree.lua
│       ├── options.lua
│       ├── treesitter.lua
│       └── trouble.lua
├── after/
│   ├── plugin/
│   │   └── setup.lua
│   └── lsp/
│       ├── html.lua
│       ├── intelephense.lua
│       ├── lua_ls.lua
│       ├── marksman.lua
│       └── tailwindcss.lua
└── nvim-pack-lock.json
```

## Load flow

### `init.lua`

Coordinates startup.

It is responsible for:

- setting leader keys
- loading core config files
- loading plugins
- defining LSP keymaps on `LspAttach`
- applying shared completion capabilities
- enabling the configured language servers

### `lua/plugins.lua`

Contains plugin registration through `vim.pack.add()`.

This file declares what is installed, not how it is configured.

### `after/plugin/setup.lua`

Runs plugin setup after plugins are available.

This keeps plugin initialization out of `init.lua` and avoids loading-order issues.

## Core config files

### `lua/config/options.lua`

Global editor options.

### `lua/config/keymaps.lua`

Global keymaps that do not depend on a specific LSP attaching.

### `lua/config/autocmds.lua`

Automation such as yank highlighting, relative number behavior, and starting Treesitter for supported filetypes.

### `lua/config/filetypes.lua`

Custom filetype detection for PrestaShop templates.

Current mappings:

- `.tpl` -> `smarty`
- `.twig` -> `twig`

## Formatting

### `lua/config/conform.lua`

Defines formatter behavior.

Current formatter strategy:

- `stylua` for Lua
- `prettier` for HTML, CSS, SCSS, JSON, YAML, Markdown, and JavaScript
- `php-cs-fixer` for PHP

For PHP, the config first looks for `vendor/bin/php-cs-fixer` upward from the file being edited. If it does not find one, it falls back to the global `php-cs-fixer` binary.

## Treesitter

### `lua/config/treesitter.lua`

Declares the parsers this repository installs explicitly.

Treesitter is only auto-started for filetypes that are covered by installed parsers in this repository.

## LSP layout

Most servers are configured under `after/lsp/`. Custom shared modules can also live under `lua/config/lsp/` when explicit registration is needed.

### `after/lsp/intelephense.lua`

Main PHP language server for PrestaShop projects.

The root markers include `composer.json` and common PrestaShop files such as:

- `config/config.inc.php`
- `config/defines.inc.php`
- `app/config/parameters.php`

### `after/lsp/html.lua`

HTML language server.

Used for:

- `html`
- `smarty`

This gives `.tpl` files useful markup support without changing their filetype away from `smarty`.

### `lua/config/lsp/twiggy_language_server.lua`

Twig-specific language server for `.twig` files.

### `after/lsp/tailwindcss.lua`

Tailwind CSS language server.

Enabled for common markup and stylesheet filetypes used around PrestaShop front-office and module work.

### `after/lsp/lua_ls.lua`

Lua language server used mainly for maintaining this Neovim configuration.

### `after/lsp/marksman.lua`

Markdown language server.

## Practical extension guide

### Add a plugin

1. Add it to `lua/plugins.lua`.
2. Configure it in `lua/config/` or `after/plugin/setup.lua`.
3. Add keymaps in `lua/config/keymaps.lua` if they are global.

### Add an LSP

1. Create `after/lsp/<name>.lua` for standard servers, or `lua/config/lsp/<name>.lua` if you want to register a custom config explicitly.
2. Define `cmd`, `filetypes`, and `root_markers`.
3. Enable it from `init.lua`.

### Add a formatter

1. Install the binary in the project or globally.
2. Register it in `lua/config/conform.lua`.

### Add a filetype

1. Declare it in `lua/config/filetypes.lua`.
2. Decide whether it also needs LSP support.
3. Decide whether it has real Treesitter parser support in this repository.

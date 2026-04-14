# Neovim Configuration Architecture

This document describes the structure of the **PrestaShop-focused** Neovim configuration in this repository.

## Design rules

- keep one responsibility per file
- keep plugin declaration separate from plugin setup
- keep global keymaps in one place
- keep plugin behavior in `lua/config/...`
- keep LSP servers split into one file per server
- defer tool-specific LSP activation until a matching filetype is opened
- keep PrestaShop-specific behavior isolated in workflow modules
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
│       │   ├── activate.lua
│       │   ├── prestashop_root.lua
│       │   ├── tailwind_root.lua
│       │   └── twiggy_language_server.lua
│       ├── nvimtree.lua
│       ├── options.lua
│       ├── treesitter.lua
│       ├── trouble.lua
│       └── workflows/
│           ├── core.lua
│           ├── helpers.lua
│           ├── init.lua
│           └── prestashop.lua
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
- registering workflow-aware LSP activation

### `lua/plugins.lua`

Aggregates plugin specs exposed by `lua/config/workflows/*`.

This file declares what is installed, not how it is configured.

### `after/plugin/setup.lua`

Runs plugin setup after plugins are available.

This keeps plugin initialization out of `init.lua` and avoids loading-order issues.
It also filters workflow-specific setup by the detected project context.

## Core config files

### `lua/config/options.lua`

Global editor options.

### `lua/config/keymaps.lua`

Global keymaps that do not depend on a specific LSP attaching.

### `lua/config/autocmds.lua`

Automation such as yank highlighting, relative number behavior, and starting Treesitter for supported filetypes.

### `lua/config/filetypes.lua`

Aggregates custom filetypes exposed by workflow modules.

Current mappings:

- `.tpl` -> `smarty`
- `.twig` -> `twig`

## Workflows

### `lua/config/workflows/*`

This branch uses a small workflow split:

- `core`
- `prestashop`

The goal is to keep central files stable while template support, PHP formatting, and project detection stay isolated in workflow modules.

## Formatting

### `lua/config/conform.lua`

Defines formatter behavior.

Current formatter strategy:

- `stylua` for Lua
- `prettier` for HTML, CSS, SCSS, JSON, YAML, Markdown, and JavaScript
- `php-cs-fixer` for PHP through the PrestaShop workflow

For PHP, the config first looks for `vendor/bin/php-cs-fixer` upward from the file being edited. If it does not find one, it falls back to the global `php-cs-fixer` binary.

## Treesitter

### `lua/config/treesitter.lua`

Declares the parsers this repository installs explicitly.

Treesitter is only auto-started for filetypes that are covered by installed parsers in this repository.

## LSP layout

Most servers are configured under `after/lsp/`. Shared activation and root helpers live under `lua/config/lsp/`.

### `after/lsp/intelephense.lua`

Main PHP language server for PrestaShop projects.

Uses `lua/config/lsp/prestashop_root.lua` to avoid attaching to unrelated PHP roots.

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

Enabled for markup and asset filetypes used around PrestaShop front-office and module work.

### `after/lsp/lua_ls.lua`

Lua language server used mainly for maintaining this Neovim configuration.

### `after/lsp/marksman.lua`

Markdown language server.

## Practical extension guide

### Add a plugin

1. Add it to the relevant workflow module under `lua/config/workflows/`.
2. Configure it in `lua/config/` or `after/plugin/setup.lua`.
3. Add keymaps in `lua/config/keymaps.lua` if they are global.

### Add an LSP

1. Create `after/lsp/<name>.lua` for standard servers, or `lua/config/lsp/<name>.lua` if you need shared helpers.
2. Define `cmd`, `filetypes`, and root detection.
3. Register activation from the relevant workflow.

### Add a formatter

1. Install the binary in the project or globally.
2. Register it in the relevant workflow and let `lua/config/conform.lua` aggregate it.

### Add a filetype

1. Declare it in the relevant workflow module.
2. Decide whether it also needs LSP support.
3. Decide whether it has real Treesitter parser support in this repository.

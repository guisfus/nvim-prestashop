# Neovim Configuration Architecture

This document describes the current structure and design principles of this Neovim configuration.

The setup may evolve over time, but the main goal stays the same: keep the config **clean, modular, and easy to maintain**.

---

## Design principles

This configuration follows a few simple rules:

- keep one responsibility per file
- keep plugin declaration separate from plugin setup
- keep global keymaps in one place
- keep plugin behavior in `lua/config/...`
- keep LSP servers split into one file per server
- prefer simple structure over clever abstractions

---

## General structure

```text
~/.config/nvim/
├── init.lua
├── lua/
│   ├── plugins.lua
│   └── config/
│       ├── options.lua
│       ├── keymaps.lua
│       ├── autocmds.lua
│       ├── filetypes.lua
│       ├── conform.lua
│       ├── treesitter.lua
│       ├── cmp.lua
│       ├── nvimtree.lua
│       ├── bufferline.lua
│       └── trouble.lua
├── after/
│   ├── plugin/
│   │   └── setup.lua
│   └── lsp/
│       ├── lua_ls.lua
│       ├── intelephense.lua
│       ├── html.lua
│       ├── tailwindcss.lua
│       ├── ts_ls.lua
│       ├── vue_ls.lua
│       ├── eslint.lua
│       └── marksman.lua
└── nvim-pack-lock.json
```

---

## How loading works

### `init.lua`

This is the **entry point** of the whole configuration.

It is responsible for:

- defining `<leader>`
- loading the base configuration
- loading plugins
- defining keymaps when an LSP attaches
- setting common LSP capabilities
- enabling the LSP servers

### `lua/plugins.lua`

This file should only do one thing:

- **register/install plugins with `vim.pack.add()`**

It is not a good place for heavy plugin setup if the plugins are not loaded yet.
That is why the actual plugin configuration lives in `after/plugin/setup.lua` or in `lua/config/...`.

### `after/plugin/setup.lua`

This runs after the plugins are available.

This is where the `require("...").setup()` calls for plugins go.

Simple plugin setup can stay here.
If a plugin grows in complexity, its behavior should move into `lua/config/<plugin>.lua`.

The mental model is:

- `plugins.lua` = which plugins exist
- `after/plugin/setup.lua` = how they are initialized

---

## Core files

### `init.lua`

Responsibility:

- coordinate the whole configuration

What to change here:

- add new `vim.lsp.enable(...)` calls
- change the general load order
- add very central global logic

What not to put here too much:

- detailed plugin setup
- editor options that already belong in another file
- global keymaps that should live in `keymaps.lua`

---

### `lua/config/options.lua`

Responsibility:

- global editor options (`vim.opt`)

Examples of things that belong here:

- line numbers
- tabs/spaces
- clipboard
- split behavior
- search behavior
- colors
- global visual details

Add something here when it is a **general editor preference**.

---

### `lua/config/keymaps.lua`

Responsibility:

- global editor keymaps that do not depend on a specific LSP

Examples:

- moving between windows
- navigating buffers
- launching `fzf-lua`
- opening `nvim-tree`
- opening `trouble`
- formatting with `conform`
- moving between diagnostics

Do not put here keymaps that only make sense when an LSP is attached if you already assign them in `LspAttach`.

---

### `lua/config/autocmds.lua`

Responsibility:

- automations using `autocmd`

Examples:

- highlight on yank
- start Treesitter when certain filetypes are opened
- set `indentexpr` for specific filetypes
- change relative numbers depending on mode

Add something here when you want **Neovim to do something automatically in response to an event**.

---

### `lua/config/filetypes.lua`

Responsibility:

- teach Neovim custom filetypes

Main example in this configuration:

- detect `*.blade.php` as `blade`

This matters because many plugins and LSPs depend on the `filetype`.

---

## Plugins and tools

### `lua/plugins.lua`

Responsibility:

- list of plugins installed with `vim.pack.add()`

Useful rule:

- if you want to add a new plugin, add it here first
- then configure it in `lua/config/...` or in `after/plugin/setup.lua`

Mental model:

- `plugins.lua` = which plugins exist
- `after/plugin/setup.lua` = how they are configured

---

### `after/plugin/setup.lua`

Responsibility:

- run the `.setup()` calls for already loaded plugins

This is where things like these live:

- `gitsigns`
- `which-key`
- `Comment`
- `nvim-autopairs`
- `lualine`
- `fzf-lua`
- `conform`
- `treesitter`
- `cmp`
- `nvim-tree`
- `bufferline`
- `trouble`

If a plugin throws `module not found` errors when configured, moving its setup here is often the right fix.

---

### `lua/config/conform.lua`

Responsibility:

- file formatting

What it does:

- assigns formatters by filetype
- allows manual formatting
- can format on save

Examples:

- `prettier` for JS/TS/Vue/JSON/HTML/CSS/SCSS/Markdown
- `stylua` for Lua
- `pint` for PHP

Important:

- `conform.nvim` does not format by itself; it orchestrates external tools
- for PHP, `pint` may come from the project itself (`vendor/bin/pint`) and not necessarily from a global system install
- LSP fallback is only used if no external formatter is available

When to edit it:

- when adding a new formatter
- when changing which tool formats a filetype
- when changing `format_on_save`

---

### `lua/config/treesitter.lua`

Responsibility:

- install Treesitter parsers
- prepare Treesitter so the editor can use them

What it does:

- installs parsers such as `lua`, `php`, `vue`, `blade`, etc.

Important:

- with the new branch/API being used, highlighting is started with `vim.treesitter.start()` from `autocmds.lua`
- this file does not decide when highlighting starts; it decides which parsers should be available

---

### `lua/config/cmp.lua`

Responsibility:

- autocompletion and snippets

What it does:

- configures `nvim-cmp`
- integrates `LuaSnip`
- integrates `nvim-autopairs`
- defines completion menu mappings
- defines sources (`lsp`, `path`, `buffer`, `luasnip`)

Important:

- part of the LSP integration is completed in `init.lua`, where the `cmp_nvim_lsp` capabilities are applied
- this file focuses on the menu, snippets, navigation, and completion UI

When to edit it:

- if you change completion keymaps
- if you add icons
- if you change `Tab` behavior
- if you add new completion sources

---

### `lua/config/nvimtree.lua`

Responsibility:

- file explorer sidebar

What it does:

- defines width, position, icons, git, diagnostics, and sync with the current file
- decides how the tree looks and behaves

Important:

- the global keymaps for the explorer do not live here; they live in `keymaps.lua`

When to edit it:

- if you want it to look more like VS Code
- if you change icons, width, or filters
- if you adjust diagnostics, git, or tree behavior

---

### `lua/config/bufferline.lua`

Responsibility:

- buffer/tab bar

What it does:

- configures the look of `bufferline`
- shows diagnostics in the bar
- integrates `bufferline` with `nvim-tree`
- controls whether the bar is always shown or only shown when it makes sense

When to edit it:

- if you change the visual style
- if you change the `nvim-tree` integration
- if you want more information in the bar

---

### `lua/config/trouble.lua`

Responsibility:

- unified diagnostics and lists view

What it does:

- configures `trouble.nvim`
- lets you view diagnostics, symbols, quickfix, and location list in a more comfortable UI

Important:

- the global Trouble keymaps live in `keymaps.lua`

When to edit it:

- if you want to change Trouble layout or behavior
- if you adjust position, filters, or display settings

---

## LSP

The `after/lsp/` folder contains **one configuration file per LSP server**.

The idea is very simple:

- each file describes how to start one server
- `init.lua` decides which ones are enabled with `vim.lsp.enable(...)`

### `after/lsp/lua_ls.lua`

Lua language server.
Used mainly for working on the Neovim config itself.

### `after/lsp/intelephense.lua`

PHP language server.
This is the main PHP/Laravel server.

It can include specific settings such as disabling `telemetry`.

### `after/lsp/html.lua`

HTML language server.
Also reused for Blade files.

### `after/lsp/tailwindcss.lua`

Tailwind CSS language server.
Very useful in Blade, Vue, HTML, and JS/TS.

### `after/lsp/ts_ls.lua`

TypeScript/JavaScript language server.
Also integrates with Vue via `@vue/typescript-plugin`.

### `after/lsp/vue_ls.lua`

Vue language server.
Works together with `ts_ls`.

### `after/lsp/eslint.lua`

ESLint language server.
Responsible for lint diagnostics and ESLint-related actions for JS/TS/Vue.

Important:

- ESLint does not format here, because formatting is handled by `conform` with `prettier`

### `after/lsp/marksman.lua`

Markdown language server.

---

## Mental guide for adding new things

### If you want to add a new plugin

1. Add it to `lua/plugins.lua`
2. Create its configuration in `lua/config/name.lua` if needed
3. Load it from `after/plugin/setup.lua`
4. If it adds global keymaps, put them in `keymaps.lua`

### If you want to add a new LSP

1. Create `after/lsp/name.lua`
2. Define `cmd`, `filetypes`, `root_markers`, `settings`, etc.
3. Enable it in `init.lua` with `vim.lsp.enable("name")`

### If you want to add a formatter

1. Install the binary outside Neovim or inside the project
2. Add it to `lua/config/conform.lua`

### If you want to add a custom filetype

1. Declare it in `lua/config/filetypes.lua`
2. If it uses Treesitter, add the parser in `treesitter.lua`
3. If needed, add queries in `queries/<filetype>/`

### If you want to automate something on open or save

- it probably belongs in `lua/config/autocmds.lua`

### If you want to change keymaps

- it probably belongs in `lua/config/keymaps.lua`

### If you want to change global editor behavior

- it probably belongs in `lua/config/options.lua`

---

## Quick summary

- `init.lua` → coordinates everything
- `plugins.lua` → plugin list
- `after/plugin/setup.lua` → plugin setup
- `options.lua` → global options
- `keymaps.lua` → global keymaps
- `autocmds.lua` → automations
- `filetypes.lua` → custom filetypes
- `conform.lua` → formatting
- `treesitter.lua` → Treesitter parsers
- `cmp.lua` → completion/snippets
- `nvimtree.lua` → file explorer
- `bufferline.lua` → buffer bar
- `trouble.lua` → diagnostics/lists UI
- `after/lsp/*.lua` → one file per LSP

---

## Golden rule

If something new enters the configuration, try to make sure it has:

- **a clear responsibility**
- **a clear file**
- **a clear reason to exist**

That is how the configuration stays clean and understandable over time.

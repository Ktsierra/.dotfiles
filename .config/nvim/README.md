# My Neovim Configuration

This is my personal Neovim configuration, built upon `kickstart.nvim` and extended with various plugins and custom settings to create a powerful and efficient development environment.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Keybindings](#keybindings)
- [Plugins](#plugins)
- [Customization](#customization)

## Features

- **Modern Plugin Management:** Powered by `lazy.nvim` for efficient and declarative plugin management.
- **Language Server Protocol (LSP) Integration:** Comprehensive support for various languages through `nvim-lspconfig` and `mason.nvim`, including enhanced TypeScript development with `typescript-tools.nvim`.
- **Advanced Autocompletion:** Fast and intelligent code completion with `blink.cmp` and snippet support via `LuaSnip`.
- **Automated Formatting & Linting:** Integrates `conform.nvim` for code formatting and `nvim-lint` for real-time linting, ensuring code quality and consistency.
- **Enhanced User Interface:**
  - `dashboard-nvim` for a clean and informative startup screen.
  - `mini.nvim` provides a minimal statusline, improved text objects, and surrounding capabilities.
  - `indent-blankline.nvim` for visual indentation guides.
  - `todo-comments.nvim` for highlighting TODOs and other annotations.
- **Efficient Navigation & Search:**
  - `telescope.nvim` for fuzzy finding files, buffers, help tags, and more.
  - `harpoon2` for quick navigation between frequently accessed files.
  - `oil.nvim` for a powerful file explorer experience.
- **Git Integration:** `gitsigns.nvim` provides visual indicators for Git changes directly in the editor.
- **Syntax Highlighting:** `nvim-treesitter` for accurate and fast syntax highlighting and structural editing.
- **Custom Themes:** Includes "Eldritch" and "Tokyonight" themes for a personalized visual experience.
- **Intuitive Keymaps:** Custom keybindings for common tasks, including LSP actions, window navigation, and plugin-specific functions.
- **Quality of Life Improvements:**
  - **Command Aliases:** Common typos like `:W` and `:Q` are automatically corrected to `:w` and `:q`.
  - **Auto-save on Buffer Change:** Files are automatically saved when switching buffers, streamlining workflows that use Telescope or Harpoon.

## Installation

This configuration assumes you have Neovim installed.

1. **Clone the repository:**

    ```bash
    git clone git@github.com:Ktsierra/.dotfiles.git ~/.dotfiles
    ```

2. **Stow the Neovim configuration:**

    ```bash
    cd ~/.dotfiles
    stow .
    ```

    This will symlink the `nvim` directory to `~/.config/nvim`.
3. **Launch Neovim:**

    ```bash
    nvim
    ```

    `lazy.nvim` will automatically install all the necessary plugins.

## Keybindings

Here are some of the notable keybindings:

- `<leader>l`: Open Lazy.nvim plugin manager.
- `<leader>m`: Open Mason.nvim for LSP and tool management.
- `<leader>f`: Format the current buffer using `conform.nvim`.
- `<leader>q`: Open the quickfix list for diagnostics.
- `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`: Navigate between Neovim windows.
- `gd`: Go to definition (LSP).
- `grn`: Rename symbol (LSP).
- `grr`: Find references (LSP).
- `<leader>c`: Code actions (LSP).
- `<leader>sh`: Search help tags (Telescope).
- `<leader>sf`: Find files (Telescope).
- `<leader>sg`: Live grep (Telescope).
- `<leader>a`: Add current file to Harpoon list.
- `<leader>hh`: Toggle Harpoon quick menu.
- `<leader>hp`: Go to previous Harpoon file.
- `<leader>hn`: Go to next Harpoon file.
- `-`: Open parent directory in `oil.nvim`.
- `<space>-`: Toggle floating `oil.nvim` window.
- `<leader>tb`: Toggle Git blame line.
- `<leader>gs`: Stage hunk (Gitsigns).
- `<leader>gr`: Reset hunk (Gitsigns).

For a complete list of keybindings, refer to `lua/keymaps.lua` and the documentation of individual plugins.

## Plugins

This configuration uses `lazy.nvim` to manage plugins. Key plugins include:

- **`neovim/nvim-lspconfig`**: Neovim's built-in LSP client.
- **`mason-org/mason.nvim`**: Installs and manages LSP servers, DAP servers, linters, and formatters.
- **`mason-org/mason-lspconfig.nvim`**: Bridges `mason.nvim` with `nvim-lspconfig`.
- **`WhoIsSethDaniel/mason-tool-installer.nvim`**: Automatically installs tools with Mason.
- **`pmizio/typescript-tools.nvim`**: Enhanced TypeScript development experience.
- **`saghen/blink.nvim`**: A comprehensive autocompletion suite.
- **`L3MON4D3/LuaSnip`**: Snippet engine.
- **`stevearc/conform.nvim`**: Code formatter.
- **`mfussenegger/nvim-lint`**: Code linter.
- **`github/copilot.vim`**: AI-powered code completion.
- **`nvimdev/dashboard-nvim`**: Startup dashboard.
- **`echasnovski/mini.nvim`**: Collection of small, useful plugins (statusline, text objects, etc.).
- **`nvim-telescope/telescope.nvim`**: Fuzzy finder.
- **`ThePrimeagen/harpoon`**: Quick file navigation (using the `harpoon2` fork).
- **`stevearc/oil.nvim`**: File explorer.
- **`lewis6991/gitsigns.nvim`**: Git integration.
- **`nvim-treesitter/nvim-treesitter`**: Parser generator and incremental parsing library.
- **`eldritch-theme/eldritch.nvim`**: Eldritch colorscheme.
- **`folke/tokyonight.nvim`**: Tokyonight colorscheme.
- **`folke/which-key.nvim`**: Displays available keybindings.
- **`lukas-reineke/indent-blankline.nvim`**: Indentation guides.
- **`folke/todo-comments.nvim`**: Highlights TODOs, FIXMEs, etc.
- **`windwp/nvim-autopairs`**: Automatic pairing of brackets, quotes, etc.
- **`windwp/nvim-ts-autotag`**: Automatic HTML/XML tag closing.
- **`NMAC427/guess-indent.nvim`**: Automatically detects tabstop and shiftwidth.
- **`nvim-neo-tree/neo-tree.nvim`**: A file explorer tree.
- **`mfussenegger/nvim-dap`**: Debug Adapter Protocol implementation.
- **`rcarriga/nvim-dap-ui`**: A UI for `nvim-dap`.
- **`williamboman/mason.nvim`**: (Already listed, but confirming its role in debugging).
- **`mrcjkb/haskell-tools.nvim`**: (This seems to be a dependency of your debug setup).
- **`jay-babu/mason-nvim-dap.nvim`**: Integrates `nvim-dap` with `mason.nvim`.
- **`isak102/config-local.nvim`**: Local configuration loader.
- **`folke/neoconf.nvim`**: Project-local configuration management.
- **`folke/neodev.nvim`**: Development environment for Neovim plugins.
- **`MunifTanjim/nui.nvim`**: UI component library.
- **`nvim-lua/plenary.nvim`**: Utility library for Neovim plugins.
- **`antoinemadec/FixCursorHold.nvim`**: A fix for a common Neovim issue.
- **`sQVe/snacks.nvim`**: Enhances the editing experience with subtle animations.

For a full list of plugins and their configurations, refer to `init.lua` and the `lua/plugins` directory.

## Customization

Feel free to explore and modify the configuration files to suit your preferences.

- `lua/opt.lua`: Contains general Neovim options.
- `lua/keymaps.lua`: Defines custom keybindings.
- `lua/autocommands.lua`: Custom autocommands.
- `lua/lsp/`: LSP-related configurations.
- `lua/plugins/`: Individual plugin configurations.
- `lua/theme/`: Colorscheme configurations.

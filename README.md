# My macOS Dotfiles

Welcome to my personal dotfiles repository! These configurations are designed to streamline my development workflow on macOS, focusing on efficiency, a clean terminal experience, and custom keybindings.

## Table of Contents

- [Setup](#setup)
- [Main Components](#main-components)
  - [Karabiner-Elements](#karabiner-elements)
  - [Aerospace](#aerospace)
  - [Shell Configuration (Zsh)](#shell-configuration-zsh)
  - [Tmux](#tmux)
  - [Neovim](#neovim)
  - [Homebrew Packages](#homebrew-packages)
- [Customization](#customization)

## Setup

This repository includes an `autobrew.sh` script that automates the installation and setup of most tools and configurations.

**Prerequisites:**

- **Xcode Command Line Tools:** The script will check for and attempt to install these.
- **Homebrew:** The script will install Homebrew if it's not already present.

**Steps:**

1. **Clone the repository:**

    ```bash
    git clone git@github.com:Ktsierra/.dotfiles.git ~/.dotfiles
    ```

2. **Run the setup script:**

    ```bash
    cd ~/.dotfiles
    ./autobrew.sh
    ```

    The script will guide you through the installation process, including Homebrew, various CLI tools, and applications.
3. **Manual Installations (if prompted by `autobrew.sh`):**
    - Install Xcode from the Mac App Store.
    - Download and install Android Studio from [https://developer.android.com/studio](https://developer.android.com/studio). Run it once to complete setup.
4. **Restart your terminal** or run `source ~/.zshrc` to apply all changes.

## Main Components

### Karabiner-Elements

- Uses a `karabiner-setup` directory to generate a complex `karabiner.json` for custom keybindings.
- **Hyper Key:** Right Command is mapped as a "Hyper" key (⌃⌥⇧⌘).
- **Application Launcher:** Hyper key combinations launch various applications (e.g., Hyper+0 for Ghostty, Hyper+1 for Safari).
- **Sublayers:**  Sublayers like 'b' for "Browse" (e.g., Hyper+b, then 't' for Twitter) and 'o' for "Open" provide organized application launching.
- **Window Management:** The 'w' sublayer integrates with Aerospace for window navigation and control.
- **System Control:** The 's' sublayer manages volume, brightness, and screen lock.
- **Tmux Control:** The 'x' sublayer provides extensive control over tmux sessions, windows, and commands.

### Aerospace

- An i3-like tiling window manager for macOS.
- The configuration (`.config/aerospace/aerospace.toml`) is set up for an accordion layout by default.
- Workspaces are configured for "M" (main) and "T" (terminal).
- Keybindings are primarily managed through Karabiner-Elements under the "w" sublayer.

### Shell Configuration (Zsh)

My `.zshrc` and `.zprofile` are configured for a powerful and efficient terminal experience:

- **NVM (Node Version Manager):** Seamlessly manage multiple Node.js versions.
- **React Native Development:** Environment variables (`ANDROID_HOME`, `JAVA_HOME`) and paths are set up for Android SDK tools.
- **SSH Agent:** Automatically adds your personal GitHub SSH key to the agent.
- **Tmux Session Cleanup:** A macOS LaunchAgent is configured to periodically run `tmuxKillSessions.sh` to clean up inactive tmux sessions.
- **macOS Key Repeat Settings:** Configures `KeyRepeat` and `InitialKeyRepeat` for a faster typing experience.
- **Homebrew Configuration:** Disables automatic Homebrew updates and configures Zsh autocompletion.
- **Starship:** Integrates the Starship prompt with the "Eldritch" theme for a highly customizable and informative command line.
- **FZF (Fuzzy Finder):** Provides interactive fuzzy search with custom keybindings and the Eldritch theme.
- **Eza:** A modern replacement for `ls`, aliased as `ls`, `ll`, `la`, `lla`, and `tree`.
- **Bat:** A `cat` clone with syntax highlighting, aliased as `cat`, `catt`, and `cata`.
- **Zsh Autosuggestions:** Offers interactive suggestions based on your command history.
- **Zoxide:** A smarter `cd` command that learns your most frequently used directories.
- **LM Studio CLI:** Path added for LM Studio command-line interface.
- **pnpm:**  Configured as the primary package manager, with `npm` aliased to `pnpm`.

### Tmux

- **Tmux Plugin Manager (TPM):** Automatically installed by `autobrew.sh`.
- **Custom Eldritch Theme:** A personalized `tmux-eldritch` theme is used.
- **Session Management:** Includes `tmux-sessionizer.sh` for quick session management and `tmuxKillSessions.sh` for automated cleanup.
- **Plugins:** Uses `tmux-resurrect` and `tmux-continuum` to save and restore sessions.

### Neovim

- **Lazy.nvim:**  Plugin manager for Neovim.
- **LSP:** Configured with `nvim-lspconfig`, `mason.nvim`, and `typescript-tools.nvim` for a rich development experience.
- **Completion:** Uses `blink.cmp` for autocompletion.
- **Formatting and Linting:** `conform.nvim` and `nvim-lint` are used for code formatting and linting.
- **UI:** `dashboard-nvim` provides a startup screen, and `mini.nvim` provides various UI enhancements.
- **Themes:** Includes "Eldritch" and "Tokyonight" themes.
- **File Management:** `oil.nvim` is used for file browsing.
- **Git Integration:** `gitsigns.nvim` provides Git integration in the gutter.

### Homebrew Packages

The `autobrew.sh` script installs a curated list of Homebrew taps, terminal packages, and cask applications. Key installations include:

- **Taps:** `nikitabobko/tap`, `sst/tap`
- **Terminal Packages:** `neovim`, `tmux`, `git`, `gh`, `awscli`, `vercel-cli`, `pnpm`, `yarn`, `nvm`, `stow`, `watchman`, `starship`, `fzf`, `eza`, `bat`, `ripgrep`, `zsh-autosuggestions`, `zoxide`, `opencode`, `gemini-cli`.
- **Cask Applications:** `font-jetbrains-mono-nerd-font`, `karabiner-elements`, `ghostty`, `nikitabobko/tap/aerospace`, `gimp`, `zulu@17` (Java JDK), `firefox`, `lm-studio`.

## Customization

Feel free to explore the individual configuration files within this repository to customize settings to your liking. The `autobrew.sh` script can be modified to add or remove packages from the `tap_list`, `term_list`, and `cask_list` variables.

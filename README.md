# My macOS Dotfiles

Welcome to my personal dotfiles repository! These configurations are designed to streamline my development workflow on macOS, focusing on efficiency, a clean terminal experience, and custom keybindings.

## Table of Contents

- [Setup](#setup)
- [Main Components](#main-components)
  - [Karabiner-Elements](#karabiner-elements)
  - [Aerospace](#aerospace)
  - [Shell Configuration (Zsh)](#shell-configuration-zsh)
  - [Tmux](#tmux)
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

- Uses a modified setup based on `mxstbr/karabiner` for custom keybindings.
- Instructions for its usage and development are located in the `karabiner-setup` folder.
- After stowing, you can run `yarn watch` within the `karabiner-setup` directory for real-time updates to your keybindings.

### Aerospace

- An i3-like tiling window manager for macOS.
- The configuration (`.config/aerospace/aerospace.toml`) is mostly plain, alternating between stacked (accordion with 0 padding) and tiled (split vertically or horizontally) layouts.
- Keybindings are primarily managed through Karabiner-Elements under the "w" sublayer, handling window swapping, resizing, and other window management tasks.

### Shell Configuration (Zsh)

My `.zshrc` and `.zprofile` are configured for a powerful and efficient terminal experience:

- **NVM (Node Version Manager):** Seamlessly manage multiple Node.js versions.
- **React Native Development:** Environment variables (`ANDROID_HOME`, `JAVA_HOME`) and paths are set up for Android SDK tools, facilitating React Native development.
- **SSH Agent:** Automatically adds your personal GitHub SSH key to the agent upon terminal startup.
- **Tmux Session Cleanup:** A macOS LaunchAgent is configured to periodically run `tmuxKillSessions.sh` to clean up inactive or old tmux sessions, keeping your environment tidy.
- **macOS Key Repeat Settings:** Configures `KeyRepeat` and `InitialKeyRepeat` for a faster and more responsive typing experience.
- **Homebrew Configuration:** Disables automatic Homebrew updates and configures Zsh autocompletion for `brew` commands.
- **Starship:** Integrates the Starship prompt for a highly customizable and informative command line prompt.
- **FZF (Fuzzy Finder):** Provides interactive fuzzy search for command history, files, and more. Includes custom keybindings (e.g., `hyper+e+n` for `tmux-sessionizer-agen`, `hyper+t+n` for `prime's tmux-sessionizer`, `hyper+c+n` for colorscheme selector), `bat` for previewing file content, and the Eldritch colorscheme.
- **Eza:** A modern replacement for `ls`, providing enhanced file listings with better defaults, colors, and icons. Aliased as `ls`, `ll`, `la`, `lla`, and `tree`.
- **Bat:** A `cat` clone with syntax highlighting and Git integration. Aliased as `cat`, `catt` (plain style, no paging), and `cata` (show all characters, plain style, no paging).
- **Zsh Autosuggestions:** Offers interactive suggestions based on your command history as you type.
- **Zoxide:** A smarter `cd` command that learns your most frequently used directories, allowing for quick "jumps" with just a few keystrokes. Aliased as `cd` and `cdd` (for `cd -`).
- **LM Studio CLI:** Path added for LM Studio command-line interface.

### Tmux

- **Tmux Plugin Manager (TPM):** Automatically installed by `autobrew.sh` to manage tmux plugins.
- **Custom Scripts:** Includes `tmux-sessionizer.sh` for quick session management and `tmuxKillSessions.sh` for automated cleanup (integrated with the LaunchAgent).

### Homebrew Packages

The `autobrew.sh` script installs a curated list of Homebrew taps, terminal packages, and cask applications. Key installations include:

- **Taps:** `nikitabobko/tap`, `sst/tap`
- **Terminal Packages:** `neovim`, `tmux`, `git`, `gh` (GitHub CLI), `awscli`, `vercel-cli`, `pnpm`, `yarn`, `nvm`, `stow`, `watchman`, `starship`, `fzf`, `eza`, `bat`, `ripgrep`, `zsh-autosuggestions`, `zoxide`, `opencode`, `gemini-cli`.
- **Cask Applications:** `font-jetbrains-mono-nerd-font`, `karabiner-elements`, `ghostty`, `nikitabobko/tap/aerospace`, `gimp`, `zulu@17` (Java JDK), `firefox`, `lm-studio`.

## Customization

Feel free to explore the individual configuration files within this repository to customize settings to your liking. The `autobrew.sh` script can be modified to add or remove packages from the `tap_list`, `term_list`, and `cask_list` variables.

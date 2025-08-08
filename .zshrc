# ~/.zshrc

# nvm setup
export NVM_DIR="$HOME/.nvm"

# brew setup
[ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"
[ -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix nvm)/etc/bash_completion.d/nvm"

# react-native setup
export ANDROID_HOME=$HOME/Library/Android/sdk && export PATH=$PATH:$ANDROID_HOME/emulator && export PATH=$PATH:$ANDROID_HOME/platform-tools
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

# console-ninja setup
PATH=~/.console-ninja/.bin:$PATH

# ssh-agent setup
# personal github
if ssh-add -l 2>/dev/null | grep -q "$(ssh-keygen -lf ~/.ssh/github_key.pub | awk '{print $2}')"; then
  # Key is already loaded in the agent
  #echo "personal github key is already loaded in the agent."
  : # No action needed
else
  # Key is not loaded; add it
  ssh-add ~/.ssh/github_key >/dev/null 2>&1
fi

# Automate tmux session cleanup every X hours using a LaunchAgent
# This will create plist file to run the script every X hours
# and log output/errors to /tmp/$PLIST_LABEL.out and /tmp/$PLIST_LABEL.err
# NOTE: If you modify the INTERVAL_SEC below, make sure to also change it in
# the ~/github/dotfiles-latest/tmux/tools/linkarzu/tmuxKillSessions.sh script
#
# 1 hour = 3600 s
INTERVAL_SEC=7200
PLIST_ID="tmuxKillSessions"
PLIST_NAME="com.ktsierra.$PLIST_ID.plist"
PLIST_LABEL="${PLIST_NAME%.plist}"
PLIST_PATH="$HOME/Library/LaunchAgents/$PLIST_NAME"
SCRIPT_PATH="$HOME/.config/tmux/$PLIST_ID.sh"

# Ensure the script file exists
if [ ! -f "$SCRIPT_PATH" ]; then
  echo "Error: $SCRIPT_PATH does not exist."
else
  # If the PLIST file does not exist, create it
  if [ ! -f "$PLIST_PATH" ]; then
    echo "Creating $PLIST_PATH..."
    cat <<EOF >"$PLIST_PATH"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$PLIST_LABEL</string>
    <key>ProgramArguments</key>
    <array>
        <string>$SCRIPT_PATH</string>
    </array>
    <key>StartInterval</key>
    <integer>$INTERVAL_SEC</integer>
    <key>StandardOutPath</key>
    <string>/tmp/$PLIST_ID.out</string>
    <key>StandardErrorPath</key>
    <string>/tmp/$PLIST_ID.err</string>
</dict>
</plist>
EOF
  fi
fi

# Check if the plist is loaded, and load it if not
if ! launchctl list | grep -q "$PLIST_LABEL"; then
  echo "Loading $PLIST_PATH..."
  launchctl load "$PLIST_PATH"
  echo "$PLIST_PATH loaded."
fi

# To unload
# launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.ktsierra.tmuxKillSessions
# Not sure why its not unloading it so I just remove the plist file
# rm $PLIST_PATH

# Set key repeat rate to 1 (fastest) and InitialKeyRepeat to 15 (fastest)
# This is for macOS to make key repeat faster
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 15

# Disable homebrew automatic updates
export HOMEBREW_NO_AUTO_UPDATE=1

# Brew autocompletion settings
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
# -v makes command display a description of how the shell would
# invoke the command, so you're checking if the command exists and is executable.
if command -v brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

# =====================================================================================
# CLI Tools
# =====================================================================================
#
# Starship
# Not sure if counts a CLI tool, because it only makes my prompt more useful
# https://starship.rs/config/#prompt
# I was getting this error
# starship_zle-keymap-select-wrapped:1: maximum nested function level reached; increase FUNCNEST?
# Check that the function `starship_zle-keymap-select()` is defined
# https://github.com/starship/starship/issues/3418
if command -v starship &>/dev/null; then
  type starship_zle-keymap-select >/dev/null ||
    {
      eval "$(starship init zsh)" >/dev/null 2>&1
    }
fi

# Initialize fzf if installed
# https://github.com/junegunn/fzf
# The following are custom fzf menus I configured
# hyper+e+n tmux-sshonizer-agen
# hyper+t+n prime's tmux-sessionizer
# hyper+c+n colorscheme selector
#
# Useful commands
# ctrl+r - command history
# ctrl+t - search for files
# ssh ::<tab><name> - shows you list of hosts in case don't remember exact name
# kill -9 ::<tab><name> - find and kill a process
# telnet ::<TAB>
#
if [ -f ~/.fzf.zsh ]; then

  # After installing fzf with brew, you have to run the install script
  # echo -e "y\ny\nn" | /opt/homebrew/opt/fzf/install

  source ~/.fzf.zsh
  source <(fzf --zsh)

  # Preview file content using bat
  export FZF_CTRL_T_OPTS="
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"

  # Use :: as the trigger sequence instead of the default **
  export FZF_COMPLETION_TRIGGER='::'

  # Eldritch Colorscheme / theme
  # https://github.com/eldritch-theme/fzf
  export FZF_DEFAULT_OPTS='--color=fg:#ebfafa,bg:#212337,hl:#37f499 --color=fg+:#ffffff,bg+:#21222c,hl+:#37f499 --color=info:#04d1f9,prompt:#f265b5,pointer:#9071f4 --color=marker:#e9f941,spinner:#f16c75,header:#7081d0'
fi

# eza
# ls replacement
# exa is unmaintained, so now using eza
# https://github.com/ogham/exa
# https://github.com/eza-community/eza
# uses colours to distinguish file types and metadata. It knows about
# symlinks, extended attributes, and Git.
if command -v eza &>/dev/null; then
  alias ls='eza'
  alias ll='eza -lhg'
  alias la='eza -ahg'
  alias lla='eza -alhg'
  alias tree='eza --tree'
fi

# Bat -> Cat with wings
# https://github.com/sharkdp/bat
# Supports syntax highlighting for a large number of programming and markup languages
if command -v bat &>/dev/null; then
  # --style=plain - removes line numbers and git modifications
  # --paging=never - doesnt pipe it through less
  alias cat='bat'
  alias catt='bat --paging=never --style=plain'
  # alias cata='bat --show-all --paging=never'
  alias cata='bat --show-all --paging=never --style=plain'
fi

# Zsh Autosuggestions
# Provides interactive suggestions based on command history and completions
# https://github.com/zsh-users/zsh-autosuggestions
# Right arrow to accept suggestion
if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Changed from z.lua to zoxide, as it's more maintaned
# smarter cd command, it remembers which directories you use most
# frequently, so you can "jump" to them in just a few keystrokes.
# https://github.com/ajeetdsouza/zoxide
# https://github.com/skywind3000/z.lua
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"

  alias cd='z'
  # Alias below is same as 'cd -', takes to the previous directory
  alias cdd='z -'

  #Since I migrated from z.lua, I can import my data
  # zoxide import --from=z "$HOME/.zlua" --merge

  # Useful commands
  # z foo<SPACE><TAB>  # show interactive completions
fi
# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/ktsierra/.lmstudio/bin"
# End of LM Studio CLI section


# pnpm
export PNPM_HOME="/Users/ktsierra/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
alias npm='pnpm'
# pnpm end

# Editor config
export EDITOR=nvim

# nvim alias
alias vim='nvim'
alias vi='nvim'
alias n='nvim'
alias nivm='nvim'
alias nv='nvim'

# lazygit alias
alias lg='lazygit'

# Ruby 3.3
export PATH="/opt/homebrew/opt/ruby@3.3/bin:$PATH"

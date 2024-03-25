#!/bin/sh
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"

# history
HISTFILE=~/.zsh_history

plug "$HOME/.config/zsh/aliases.zsh"
plug "$HOME/.config/zsh/exports.zsh"

# Plugins
# plug "esc/conda-zsh-completion"
plug "zsh-users/zsh-autosuggestions"
plug "hlissner/zsh-autopair"
plug "zap-zsh/supercharge"
plug "zap-zsh/vim"
plug "zap-zsh/fzf"
# plug "zap-zsh/exa"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-history-substring-search"
plug "zap-zsh/sudo"
plug "chivalryq/git-alias"
plug "Freed-Wu/fzf-tab-source"
plug "wintermi/zsh-lsd"
plug "Aloxaf/fzf-tab"
plug "zap-zsh/completions"
plug "MichaelAquilina/zsh-you-should-use"

# Prompts
plug "MAHcodes/distro-prompt"
# plug "spaceship-prompt/spaceship-prompt"
# plug "zap-zsh/atmachine-prompt"
# plug "zap-zsh/zap-prompt"
# plug "zap-zsh/singularisart-prompt"

# keybinds
bindkey '^ ' autosuggest-accept

export PATH="$HOME/.local/bin":$PATH

if command -v bat &> /dev/null; then
  alias cat="bat -pp --theme \"Visual Studio Dark+\"" 
  alias catt="bat --theme \"Visual Studio Dark+\"" 
fi

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# BOD
# Load and initialise completion system
autoload -Uz compinit
compinit

# Switch to vi command mode without [ESC]
bindkey 'kj' vi-cmd-mode

# eval "$(starship init zsh)"
# export STARSHIP_CONFIG=~/.config/zsh/starship.toml

# source $HOME/config/broot/launcher/bash/br

# To have your prompt indicate that you are within a shell that will return you to nnn when you are done. nnn is an ncurses file manager. This together with #cd on quit (Ctrl-G) becomes a powerful combination.
# [ -n "$NNNLVL" ] && PS1="N$NNNLVL $PS1"

# if [ -f /usr/share/nnn/quitcd/quitcd.bash_zsh ]; then
    # source /usr/share/nnn/quitcd/quitcd.bash_zsh
# fi

# fnm
# eval "`fnm env`"

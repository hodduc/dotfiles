# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="steeef"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git aws brew kubectl)

source $ZSH/oh-my-zsh.sh

# User configuration

alias ls="ls --color=auto"
export XDG_CONFIG_HOME="$HOME/.config"

# Replace ag with https://github.com/aykamko/tag
# Replace ack with ag
if hash ag 2>/dev/null; then
  export TAG_CMD_FMT_STRING="nvim {{.Filename}} +{{.LineNumber}}"
  tag() { command tag "$@"; source ${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null }
  alias ag=tag
  alias ack=ag
fi

# Add brew-related packages to PATH
brew_prefix="$(brew --prefix)"

function load_brew_package {
	export PATH="$brew_prefix/opt/$1:$PATH"
}

function load_brew_library {
	export LIBRARY_PATH="$brew_prefix/opt/$1:$LIBRARY_PATH"
}

function brew.info {
  grep desc $brew_prefix/Library/Formula/*.rb | perl -ne 'm{^.*/(.*?)\.rb.*?\"(.*)"$} and print "$1|$2\n"' | column -t -s '|' | fzf --reverse
}

export PATH="/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:$PATH"

load_brew_package less/bin
load_brew_package vim/bin
load_brew_package ctags/bin
load_brew_package coreutils/libexec/gnubin
load_brew_package gzip/bin
load_brew_library leveldb/lib

# Set GOPATH
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"

# Set virtualenvwrapper to use python3 default
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
source /usr/local/bin/virtualenvwrapper.sh

# Aliases
alias clearvimswp="rm -rf ~/.vim/tmp/*"
alias dnsreset="sudo networksetup -setdnsservers Ethernet 8.8.8.8 8.8.4.4"
alias vi=nvim

# Iterm2-shell integration
source /Users/hodduc/.iterm2_shell_integration.zsh

# Use fzf if installed
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Wrap git with hub
eval "$(hub alias -s)"

# Override local zshrc
[ -f ~/.zshrc_local ] && source ~/.zshrc_local

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/vault vault

export GPG_TTY=$(tty)

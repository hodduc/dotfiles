# Load asdf & prelaod script if exists. Some oh-my-zsh plugins requires a binary exists in PATH (ex. kubectl)
[ -f ~/.asdf/bin/asdf ] && source ~/.asdf/asdf.sh
[ -f ~/.zshrc_preload ] && source ~/.zshrc_preload

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export PATH="$PATH:$HOME/.local/bin:$HOME/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

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
plugins=(git aws docker terraform z dotenv)

command -v kubectl &> /dev/null && plugins+=(kubectl kube-ps1)
command -v brew &> /dev/null && plugins+=(brew)
[ -f ~/.asdf/bin/asdf ] && plugins+=(asdf)

source $ZSH/oh-my-zsh.sh

# Load cargo if exists
[ -f ~/.cargo/env ] && source ~/.cargo/env

# User configuration

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# Replace ag with https://github.com/aykamko/tag
# Replace ack with ag
if hash rg 2>/dev/null; then
  export TAG_SEARCH_PROG=rg
  export TAG_CMD_FMT_STRING="nvim {{.Filename}} +{{.LineNumber}}"
  tag() { command tag "$@"; source ${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null }
  alias ack=tag

  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

# Replace ls with https://github.com/ogham/exa
if hash exa 2>/dev/null; then
	export EXA_COLORS="da=0:uu=0"  # disable datetime/user color
	alias ls="exa -F"
else
	alias ls="ls --color=auto"
fi

# Replace cat with https://github.com/sharkdp/bat
if hash bat 2>/dev/null; then
	alias cat="bat -pp"  # disable line number & paging
fi

if hash brew 2>/dev/null; then
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

	load_brew_package less/bin
	load_brew_package vim/bin
	load_brew_package ctags/bin
	load_brew_package coreutils/libexec/gnubin
	load_brew_package gzip/bin
	load_brew_library leveldb/lib
fi

# Set virtualenvwrapper to use python3 default
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
[ -f /usr/local/bin/virtualenvwrapper.sh ] && source /usr/local/bin/virtualenvwrapper.sh

# Aliases
alias clearvimswp="rm -rf ~/.vim/tmp/*"
alias dnsreset="sudo networksetup -setdnsservers Ethernet 8.8.8.8 8.8.4.4"
alias vi=nvim
alias kc=kubectl

# Iterm2-shell integration
[ -f ~/.iterm2_shell_integration.zsh ] && source /Users/hodduc/.iterm2_shell_integration.zsh

# Use fzf if installed
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Wrap git with hub
command -v hub &> /dev/null && eval "$(hub alias -s)"

# Override local zshrc
[ -f ~/.zshrc_local ] && source ~/.zshrc_local

# Autocompletion
# To load a completion to zsh, put the zsh_completion file to ~/.zsh/completions/

fpath=($HOME/.zsh/completions $fpath)
autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

complete -o nospace -C vault vault

export GPG_TTY=$(tty)
export PIPENV_VENV_IN_PROJECT=1
export EDITOR=nvim

export RIPGREP_CONFIG_PATH=$HOME/repos/dotfiles/ripgreprc

if [[ "$OSTYPE" == darwin* ]]; then
	bindkey "^[^[[D" backward-word # option + <-
	bindkey "^[^[[C" forward-word  # option + ->
fi

RPROMPT=$RPROMPT$'%{$fg[white]%}$(tf_prompt_info)%{$reset_color%} '

# Load zinit if installed
if [[ -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
	source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
	autoload -Uz _zinit
	(( ${+_comps} )) && _comps[zinit]=_zinit

	# Load a few important annexes, without Turbo
	# (this is currently required for annexes)
	zinit light-mode for \
			zdharma-continuum/zinit-annex-as-monitor \
			zdharma-continuum/zinit-annex-bin-gem-node \
			zdharma-continuum/zinit-annex-patch-dl \
			zdharma-continuum/zinit-annex-rust

	zinit light jonmosco/kube-ps1
	RPROMPT='$(kube_ps1)'$RPROMPT

	zinit light zdharma/fast-syntax-highlighting
	zinit light zsh-users/zsh-autosuggestions
	zinit light zsh-users/zsh-completions

	zinit ice bpick'kubectx;kubens' from'gh-r' sbin'kubectx;kubens' nocompletion
	zinit load ahmetb/kubectx
fi

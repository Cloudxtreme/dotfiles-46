if [ "$(uname)" = "Darwin" ]; then
  export GREP_OPTIONS='--color=always'
  export GREP_COLOR='1;35;40'
fi
export TERM=xterm-256color
export EDITOR=emacs
export LSCOLORS=exfxcxdxbxegedabagacad
export CLICOLOR=true
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
export ZSH_CACHE_DIR=$HOME/.zsh/cache

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# don't nice background tasks
setopt NO_BG_NICE
setopt NO_HUP
setopt NO_LIST_BEEP
# allow functions to have local options
setopt LOCAL_OPTIONS
# allow functions to have local traps
setopt LOCAL_TRAPS
# share history between sessions ???
setopt SHARE_HISTORY
# add timestamps to history
setopt EXTENDED_HISTORY
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
# adds history
setopt APPEND_HISTORY
# adds history incrementally and share it across sessions
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
# don't record dupes in history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt HIST_EXPIRE_DUPS_FIRST
# dont ask for confirmation in rm globs*
setopt RM_STAR_SILENT

# completion
autoload -Uz compinit; compinit -i
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# antibody
if [[ ! -e "$HOME/.zsh_plugins.sh" ]]; then
    # Fetch plugins.
    antibody bundle < "$HOME/.zsh_plugins.txt" > "$HOME/.zsh_plugins.sh"
fi
source ~/.zsh_plugins.sh

# ssh & gpg
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"
eval "$(gpgconf --launch gpg-agent)"
echo UPDATESTARTUPTTY | gpg-connect-agent 1>/dev/null
if [ "$SSH_AUTH_SOCK" ] && [ $(ssh-add -l >| /dev/null 2>&1; echo $?) = 1 ]; then
    ssh-add
fi

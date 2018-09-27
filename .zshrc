#!/bin/zsh

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

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

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

# antibody
if [[ ! -e "$HOME/.zsh_plugins.sh" ]]; then
    # Fetch plugins.
    antibody bundle < "$HOME/.zsh_plugins.txt" > "$HOME/.zsh_plugins.sh"
fi
source ~/.zsh_plugins.sh


export GPG_TTY=$(tty)
export SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"
eval "$(gpgconf --launch gpg-agent)"
echo UPDATESTARTUPTTY | gpg-connect-agent 1>/dev/null

# If the SSH agent is running then add any keys.
if [ "$SSH_AUTH_SOCK" ] && [ $(ssh-add -l >| /dev/null 2>&1; echo $?) = 1 ]; then
    ssh-add
fi

## ENVIRONMENT
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=emacs
export CDPATH=".:~"
#export PYTHONDONTWRITEBYTECODE=1
export PYTHONSTARTUP=~/.pythonrc
export PYTHONPATH=".:/usr/local/lib/python2.7/site-packages/"
export WORKON_HOME=~/Envs
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
#export DJANGO_SETTINGS_MODULE="settings"
#export DOCKER_HOST=tcp://172.16.42.43:4243
#export DOCKER_HOST=tcp://127.0.0.1:14243
export DOCKER_HOST=tcp://172.18.42.1:4243
#export HOSTFILE=~/.hosts
export GOPATH="$HOME/go"
export GREP_OPTIONS='--color=auto'

# Boot2docker
export DOCKER_HOST=tcp://192.168.59.103:2376
# export DOCKER_HOST=tcp://$(boot2docker ip 2>/dev/null):2375
export DOCKER_CERT_PATH=/Users/moul/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1

## ALIASES
#alias venv=". ~/venv/bin/activate"
alias emacs="emacs -nw"
#alias brew="brew growl"


## FUNCTIONS
etc_hosts_ips() {
    COMPREPLY=($(sed 's/^\([0-9\.]*\).*$/\1/g;/^$/d' /etc/hosts | sort | uniq | grep "^${COMP_WORDS[COMP_CWORD]}"))
}

ssh_config_hosts() {
    COMPREPLY=($(cat ~/.ssh/config | sed '/^[hH]ost\ [a-zA-Z0-9\._-]*$/!d;s/^.ost\ //g' | grep "^${COMP_WORDS[COMP_CWORD]}" | sort | uniq))
}
ssh_knownhosts_hosts() {
    COMPREPLY=($(cat ~/.ssh/known_hosts | \
        cut -f 1 -d ' '  | \
        sed -e s/,.*//g | \
        grep -v ^# | \
        uniq | \
        grep -v "\["))
}

color()(set -o pipefail;"$@" 2>&1>&3|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1

## HISTORY
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#HISTCONTROL=ignoreboth
shopt -s histappend
shopt -s checkwinsize
export HISTSIZE=1000000
export HISTFILESIZE=1000000
HISTIGNORE='ls:bg:fg:history'
PROMPT_COMMAND="${PROMPT_COMMAND} history -a; " # store history on each new line

## PATH PREFIX
for path in \
    $HOME/.cabal/bin \
    $HOME/node_modules/.bin \
    /usr/local/share/npm/bin \
    /usr/local/bin \
    /usr/local/sbin \
    $HOME/mbin \
    $HOME/mbin2 \
    ; do
    if [ -d $path ]; then
        export PATH="$path:$PATH"
    fi
done


## GIT ACHIEVEMENTS
if [ -d ~/Git/watch/icefox/git-achievements ]; then
    alias git="~/Git/watch/icefox/git-achievements/git-achievements"
fi


## PROMPT
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac
force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
PS1_PREFIX=""
unset color_prompt force_color_prompt


## BASH COMPLETION
complete -A hostname -F etc_hosts_ips ping
complete -A hostname -F ssh_config_hosts ssh csshX ssh-manfred.sh ssh_master csshx pssh logssh cssh mosh mosh-manfred.sh hostname
complete -A hostname -A file -F ssh_config_hosts scp rsync
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
for dir in /usr/local/etc/bash_completion.d; do
    #echo $dir
    if [ -d $dir ]; then
        for file in $dir/*; do
            if [ -x $file ]; then
                #echo "[+] $file"
                . $file
            else
                #echo "[-] $file"
                source $file 2>/dev/null
            fi
        done
    fi
done
COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS


## LOAD DEPENDENCIES
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
BREW_PREFIX=$(brew --prefix)
for file in \
    "$BREW_PREFIX/etc/bash_completion" \
    "$BREW_PREFIX/etc/grc.bashrc" \
    "$BREW_PREFIX//bin/virtualenvwrapper.sh" \
    "$HOME/.bash_local" \
    "$HOME/.bash_private" \
    ; do
    if [ -f $file ]; then
        . $file
    fi
done


# PYTHON
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
check_virtualenv() {
    if [ -e .venv ]; then
        env=`cat .venv`
        if [ "$env" != "${VIRTUAL_ENV##*/}" ]; then
            echo "Found .venv in directory. Calling: workon ${env}"
            workon $env
        fi
    fi
}
venv_cd () {
    builtin cd "$@" && check_virtualenv
}
workon_safe() {
    if [ "x${VIRTUAL_ENV}" == "x" ]; then
        workon $@
    fi
}
check_virtualenv
alias cd=venv_cd


## "modularity"
PS1="$PS1_PREFIX$PS1"
unset PS1_PREFIX



## CLEAN
unset BREW_PREFIX

# added by travis gem
[ -f /Users/moul/.travis/travis.sh ] && source /Users/moul/.travis/travis.sh

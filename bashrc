#!/usr/bin/env bash
## .bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

#################################################################
# Variables
#################################################################

PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:$HOME/bin

################################################################
# Aliases
################################################################

alias ls='ls --color=always'; export ls

function cdiff() {
    diff -u $@ | sed "s/^-/\x1b[31m-/;s/^+/\x1b[32m+/;s/^@/\x1b[34m@/;s/$/\x1b[0m/"
}
alias diff='cdiff'
alias less='less -R'

################################################################
# Shell config
################################################################

# Enable 256 colors
if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    TERM='gnome-256color';
else
    TERM='linux'
fi

# Enable sane home/pgup/pgdown/end keys
# http://askubuntu.com/a/206722
stty sane

# Enable UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Enable X11 forwarding
if [ -z "$DISPLAY" ]; then
    IP_ADDR=$(echo $SSH_CLIENT | awk '{{print $1}}')
    export DISPLAY=$(echo $IP_ADDR:0)
fi

################################################################
# ssh agent
################################################################

function ssh_start() {
    eval `ssh-agent -s`
    ssh-add
}

################################################################
# Keyboard bindings
################################################################

#bind '"\e[A": history-search-backward'
#bind '"\e[B": history-search-forward'

################################################################
# Shell prompt
################################################################

source ~/.bash/git-prompt
source ~/.bash/git-completion

# Set the terminal title to the current working directory.
PS1="\[\033]0;\w\007\]\[\]";
PS1+="\[\e[1;33m\]\u"
PS1+="\[\e[1;37m\]@\[\e[1;31m\]\h"
PS1+="\[\e[1;37m\]:\[\e[1;32m\]\w"
PS1+="\$(prompt_git \"\e[1;37m [\e[1;35m\")"
PS1+="\[\e[1;37m\]]\$ \[\e[0m\]"

PS2="\[\e[1;33m\]→ \[\e[0m\]"

# Show process name in tab title bar
#   source: http://stackoverflow.com/q/10546217

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    # don't print full PWD path:
    #   source: http://stackoverflow.com/q/1371261
    export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD##*/}\007"'
    ;;
*)
    ;;
esac

###############################################################
# Additional settings
#

if [ -e ~/.local/proxy ]; then
    source ~/.local/proxy
fi

if [ -e ~/.local/aliases ]; then
    source ~/.local/aliases
fi

if [ -e ~/.bash/ls_colors ]; then
    source ~/.bash/ls_colors
fi

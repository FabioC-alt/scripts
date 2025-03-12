#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

PS1='[\u@\h \W]\$ '

# Aliases

alias ll="ls -l"
alias s="sudo"
alias k="kubectl"
alias z="zellij"

# Programs

eval "$(mcfly init bash)"

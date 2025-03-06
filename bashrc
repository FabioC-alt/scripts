#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
alias ll="ls -l"
alias s="sudo"
alias k="kubectl"
source < (kubectl completion bash)
eval "$(mcfly init bash)"

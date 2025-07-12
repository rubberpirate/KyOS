# .bashrc for KyOS Live User

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Basic prompt
PS1='[\u@\h \W]\$ '

# Some useful aliases
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# If this is the first login and we're on tty1, start the desktop
if [[ -z "$DISPLAY" && "$XDG_VTNR" = "1" ]]; then
    # Only auto-start once
    if [[ ! -f /tmp/.kyos-desktop-started ]]; then
        touch /tmp/.kyos-desktop-started
        exec bash ~/.bash_profile
    fi
fi

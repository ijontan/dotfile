# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe.sh ] && eval "$(SHELL=/bin/sh lesspipe.sh)"

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias lll='exa --icons -alF'
alias ll='exa --icons -AlF'
alias l='exa --icons -lF'

alias open='thunar'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

function sd {
    cd "$(find ${1:-*} -maxdepth 4 -type d -not -path "*.git*" -not -path "*.cache*" -not -path "*node_modules*" -not -path "*cpptools*" | fzf)";
}

function op {
    (cd "$(find ${1:-*} -maxdepth 4 -type d -not -path "*.git*" -not -path "*.cache*" -not -path "*node_modules*" -not -path "*cpptools*" | fzf)" && tmux;)
}

function nv {
    nvim "$@"
}

function g {
    git "$@"
}

function ga {
    git add ${@:--A}
}

function gc {
    git commit "$@"
}

function gco {
    git checkout ${@:--}
}

function gp {
    git pull "$@"
}

function gP {
    git push "$@"
}

function gr {
    git remote "$@"
}

function gb {
    git branch "$@"
}

function tm {
    tmux "$@"
}

function tma {
    if [ -z "$@" ]
    then
	tmux a -t $(tmux ls | fzf | cut -d ':' -f1)
    else
	tmux a -t ${1}
    fi
}

function initcpp {
    mkdir src includes
    sed "s_tempname_${1:-a.out}_g" ~/dotfile/Makefile.template > "Makefile"
    sed "s_RelativePath_$(pwd)_g" ~/dotfile/.clangd.template > ".clangd"
    echo "${1:-a.out}" >> .gitignore
}

function tml {
    tmux ls
}

function pskill {
    pid=$(ps -e | sed "1d" | fzf | awk '{print $1}')
    [ -z "$pid" ] || kill $pid
}

# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(fzf --bash)"
eval "$(oh-my-posh init bash --config $HOME/dotfile/mytheme.omp.json)"
export FLYCTL_INSTALL="/home/ijon/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/var/lib/snapd/snap/bin:$PATH"
export EDITOR=/home/linuxbrew/.linuxbrew/bin/nvim
export VISUAL=/home/linuxbrew/.linuxbrew/bin/nvim
export LC_COLLATE=C
export FZF_SKIP=".git,node_modules,target,.cache,.icons,.themes,.steam,.local,.gradle"
export FZF_DEFAULT_OPTS="--reverse"
export FZF_CTRL_T_OPTS="
  --walker-skip $FZF_SKIP
  --preview 'bat -n --color=always --line-range 0:500 {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
export FZF_ALT_C_OPTS="
  --walker-skip $FZF_SKIP
  --preview 'exa --tree --level=3 --icons --color=always {} | head -n 500'"
bind 'TAB:menu-complete'
bind 'set show-all-if-ambiguous on'
bind -f  ~/.inputrc

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
# . "$HOME/.cargo/env"
# MANPATH=/usr/share/man

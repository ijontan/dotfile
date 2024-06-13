# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $(ZINIT_HOME))"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# syntax highlight
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# snippits
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

autoload -U compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# completions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(S.:.)LS_COLORS}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --long --tree --level 3 $realpath'

# aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ls='eza --icons'
alias lll='exa --icons -alF'
alias ll='exa --icons -AlF'
alias l='exa --icons -lF'
alias nv='nvim'
alias open='thunar'
alias tm='tmux'
alias tma='tmux a -t $(tmux ls 2> /dev/null | fzf | cut -d ':' -f1)'



# env
export FZF_SKIP=".git,node_modules,target,.cache,.icons,.themes,.steam,.local,.gradle,.npm,game,.wine"
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

function pskill {
  pid=$(ps -e | sed "1d" | fzf | awk '{print $1}')
  [ -z "$pid" ] || kill $pid
}
function op {
  (cd "$(find ${1:-*} -maxdepth 4 -type d -not -path "*.git*" -not -path "*.cache*" -not -path "*node_modules*" -not -path "*cpptools*" | fzf --preview 'exa --tree --level=3 --icons --color=always {} | head -n 500')" && tmux;)
}
# shell intergration
eval "$(fzf --zsh)"

#!/usr/bin/env bash

export FZF_DEFAULT_OPTS="--reverse"

declare -A menu_options=(
    ["Hyprland"]="$HOME/.config/hypr"
    ["Kitty"]="$HOME/.config/kitty"
    ["Neovim"]="$HOME/.config/nvim"
    ["Scripts"]="$HOME/dotfile/scripts"
    ["Keyd"]="/etc/keyd"
)

selected=$(printf "%s\n" "${!menu_options[@]}" | fzf --border=rounded --border-label=" Quick Edit ")

if [ -z "$selected" ]; then
	exit 1
fi

path="${menu_options[$selected]}"

kitty --detach sh -c "cd \"$path\" && nvim"

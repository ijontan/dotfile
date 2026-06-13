#!/usr/bin/env bash

declare -A menu_options=(
    ["Hyprland"]="$HOME/.config/hypr"
    ["Kitty"]="$HOME/.config/kitty"
    ["Neovim"]="$HOME/.config/nvim"
    ["Keyd"]="/etc/keyd"
)

selected=$(printf "%s\n" "${!menu_options[@]}" | fzf)

if [ -z "$selected" ]; then
	exit 1
fi

path="${menu_options[$selected]}"
cd "$path" && nvim

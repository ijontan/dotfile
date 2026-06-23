#!/usr/bin/env bash

export FZF_DEFAULT_OPTS="--reverse"

projects_dir="$HOME/src"

selected=$(fd -t d -d 1 . "$projects_dir" | fzf --border=rounded --border-label=" Open Project ")

if [ -z "$selected" ]; then
	exit 1
fi

kitty --detach sh -c "cd \"$selected\" && nvim"

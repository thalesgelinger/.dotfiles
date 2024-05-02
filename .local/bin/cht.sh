#!/usr/bin/env bash

languages=$(echo "typescript javascript golang rust java swift kotlin objective-c lua" | tr " " "\n")
commands=$(echo "find xargs sed curl tmux awk" | tr " " "\n")

selected=$(echo -e "$languages\n$commands" | fzf)

read -p "Enter Query: " query

if  echo "$languages" | grep -qs $selected; then
    tmux neww sh -c "curl cht.sh/$selected/$(echo "$query" | tr " " "+") | less -R"
else
    tmux neww sh -c "curl cht.sh/$selected~$(echo "$query" | tr " " "-") | less -R"
fi


#!/bin/sh

for i in *; do
    if [ -d "$i" ]; then
	title=$(sed -nE 's/^# (.*)/\1/p' < "$i/index.md" | head -n 1)
	printf -- '- [%s - %s](%s)' "$i" "$title" "$i"
    fi
done | ../mkpage.sh

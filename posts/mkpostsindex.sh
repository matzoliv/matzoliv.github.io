#!/bin/sh

(
	printf "# Posts ([rss](/rss.xml))\n"
	for i in *; do
		if [ -d "$i" ]; then
			title=$(sed -nE 's/^# (.*)/\1/p' < "$i/index.md" | head -n 1)
			printf -- '- [%s - %s](%s)\n' "$i" "$title" "$i"
		fi
	done | sort -r
) | ../mkpage.sh Posts

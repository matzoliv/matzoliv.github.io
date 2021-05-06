#!/bin/sh

(
	lastPubDate=$(find posts/* -maxdepth 1 -type d | sort -r | head -n1 | sed -En 's/posts\/(.*)/\1/p')
	cat - <<EOF
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>omatz</title>
    <link>https://omatz.xyz/</link>
    <language>en-us</language>
    <pubDate>$(date -d $lastPubDate -Ru)</pubDate>
EOF
	for i in posts/*; do
		if [ -d "$i" ]; then
			echo "$i"
		fi
	done | sort -r | while read post; do
		title=$(sed -nE 's/^# (.*)/\1/p' < "$post/index.md" | head -n 1)
		pubDate=$(echo $post | sed -En 's/posts\/(.*)/\1/p')
		cat - <<EOF
	<item>
	  <title>$title</title>
	  <link>https://omatz.xyz/$post</link>
	  <pubDate>$(date -d $pubDate -Ru)</pubDate>
	  <guid>https://omatz.xyz/$post</guid>
	</item>
EOF
	done

	cat - <<EOF
  </channel>
</rss>
EOF
)

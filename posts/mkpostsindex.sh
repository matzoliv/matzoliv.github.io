#!/bin/sh

cat - << EOF
<!DOCTYPE html>
<html>
  <head>
    <title>omatz</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link rel="stylesheet" href="/style.css">
  </head>
  <body>
    <div id="header">
      <div id="title"><a href="/">omatz</a></div>
    </div>

    <hr/>

    <h1>Posts</h1>

    <ul>
EOF

for i in *; do
    if [ -d "$i" ]; then
	title=$(sed -nE 's/^# (.*)/\1/p' < "$i/index.md" | head -n 1)
	printf '<li><a href="%s">%s - %s</a></li>' "$i" "$i" "$title"
    fi
done

cat - << EOF
    </ul>
  </body>
</html>
EOF


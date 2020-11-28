#!/bin/sh

cat - << EOF
<!DOCTYPE html>
<html>
  <head>
    <title>omatz - $1</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link rel="stylesheet" href="/style.css">
  </head>
  <body>
    <div id="header">
      <div id="title"><a href="/">omatz</a></div>
    </div>

    <hr/>
EOF

markdown

cat - << EOF
  </body>
</html>
EOF


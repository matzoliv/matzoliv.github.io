#!/bin/sh

if [ ! -z "$1" ]; then
    title_suffix=" - $1"
else
    title_suffix=""
fi

# <link rel="stylesheet" href="https://cdn.simplecss.org/simple.min.css">

cat - << EOF
<!DOCTYPE html>
<html>
  <head>
    <title>omatz$title_suffix</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link rel="stylesheet" href="/sp.css">
  </head>
  <body>
    <header>
      <h3><a href="/">omatz</a></h3>
      <nav>
        <a href="/">About</a>
        <a href="/posts/">Posts</a>
      </nav>
    </header>

    <main>
EOF

markdown -f fencedcode,smarty

cat - << EOF
    </main>
  </body>
</html>
EOF

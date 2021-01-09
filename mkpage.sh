#!/bin/sh

if [ ! -z "$1" ]; then
    title_suffix=" - $1"
else
    title_suffix=""
fi

# <link rel="stylesheet" href="/pico.slim.min.css">

cat - << EOF
<!DOCTYPE html>
<html>
  <head>
    <title>omatz$title_suffix</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link rel="stylesheet" href="https://cdn.simplecss.org/simple.min.css">
  </head>
  <body>
    <header>
      <h1>omatz</h1>
      <nav>
        <a href="/">About</a>
        <a href="/posts/">Posts</a>
        <a href="/software.html">Software</a>                
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


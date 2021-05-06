# My RSS toolbox

I've developped my own RSS feed reading system as a set of small
composable scripts. The code can be found here :
[https://github.com/oliviermatz/rss-toolbox](https://github.com/oliviermatz/rss-toolbox).

There's an `example.sh` file in the repository that show cases how to implement
common use cases. Here, we'll dive into the purpose of each parts so that you can
compose your own.

First step, let's use curl to grab the data.

```shell
curl --compressed -L -s https://ferd.ca/feed.rss
```

Then, we'll convert the XML to a format more amenable to being processed
with UNIX tools. We'll opt for TSV, that is, one entry per line, tab-separated
fields in order :

```
<entry id>	<timestamp>	<title>	<url>
```

I found that the
easiest way to do this is through a python script using the base `ElementTree`
library. Scripts that should cover the vast majority of cases can be found [here](https://github.com/oliviermatz/rss-toolbox/tree/master/feed2tsv).
Because the data might vary from website to website, you might need to make a custom
one for a particular website. All that matters is that you end up writing the same
format as shown above.

```
curl --compressed -L -s https://ferd.ca/feed.rss | \
    ./feed2tsv/rss2tsv.py
```

Now we need a way to detect novelty. `print_new_update.py` is a script that reads TSV
entries in its standard input, and will write back only lines that it never seen before.
State is stored in a text file whose path you provide as a command line parameter.

```
curl --compressed -L -s https://ferd.ca/feed.rss | \
    ./feed2tsv/rss2tsv.py | \
    ./print_new_update.py ferd.seen
```

Next we want a way to browse what we found. I like to use my emails in Maildir format
for all sorts of things, and it's a perfect fit to browse RSS feeds too. `write_to_maildir.sh`
is a script that uses the great [mblaze](https://github.com/leahneukirchen/mblaze) tools
to create new entries in a Maildir folder. All scripts will also write back the lines they
consumed in their standard output so that they can be chained.

```
curl --compressed -L -s https://ferd.ca/feed.rss | \
    ./feed2tsv/rss2tsv.py | \
    ./print_new_update.py ferd.seen | \
    ./write_to_maildir.sh ferd ~/mail/rss/blogs/
```

Another thing I like to do is read web content from my Kindle. I've played around
with many ways to convert web pages to something readable on a Kindle screen, but I've
finally settled on printing A6 format PDFs of mobile versions of website using Chromium
and [puppeteer](https://github.com/puppeteer/puppeteer/). [url2pdf]() is a small node
tools that takes a URL and will output a PDF of a format perfectly readable on a Kindle
paperwhite. `make_pdfs.sh` is a script that uses `url2pdf` and reads TSV data to ouptut
kindle PDFs to a given directory.

```
curl --compressed -L -s https://ferd.ca/feed.rss | \
    ./feed2tsv/rss2tsv.py | \
    ./print_new_update.py ferd.seen | \
    ./write_to_maildir.sh ferd ~/mail/rss/blogs/ | \
    ./make_pdfs.sh ferd /media/omatz/Kindle/documents/web
```

Using this pattern, there's so much more that can be done. Automatically download
podcast (printing the "enclosure" url instead of the "link"), or download content
from youtube channels using `youtube-dl`, the possibilities are endless.

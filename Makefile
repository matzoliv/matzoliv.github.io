.PHONY: clean posts

ALL_MDS := $(shell find . -name '*.md')
ALL_HTMLS := $(ALL_MDS:.md=.html)

clean:
	find . -name '*.html' -exec rm {} \;

posts:
	cd posts/ && ./mkpostsindex.sh > index.html

%.html: %.md mkpage.sh
	./mkpage.sh $(shell sed -nE 's/^# (.*)/\1/p' < $< | head -n 1) < $< > $@

all: ${ALL_HTMLS} posts

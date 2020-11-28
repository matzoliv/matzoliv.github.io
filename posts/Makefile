.PHONY: clean all posts

ALL_MDS := $(shell find . -name '*.md')
ALL_HTMLS := $(ALL_MDS:.md=.html)

clean:
	find . -name '*.html' -exec rm {} \;

posts:
	cd posts && ./mkpostsindex.sh

%.html: %.md mkpage.sh
	./mkpage.sh < $< > $@

all: ${ALL_HTMLS} posts

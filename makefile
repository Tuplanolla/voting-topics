DOT=dot
# DOTFLAGS=-Gfontname=sans -Nfontname=sans -Gfontsize=12 -Nfontsize=10
CPP=gcc
CPPFLAGS=-C -E -P -nostdinc -w -xc \
	-D'whitesmoke="\#ffffff"' \
	-D'darkslateblue="\#1d3d66"' \
	-D'snow="\#ffffff"' \
	-D'midnightblue="\#1d3d66"' \
	-D'lightgray="\#cacac7"' \
	-D'darkslategray="\#1d3d66"' \
	-D'gainsboro="\#cacac7"' \
	-D'tomato="\#dd583d"' \
	-D'ghostwhite="\#ffffff"' \
	-D'orangered="\#dd583d"' \
	-D'indianred="\#dd583d"' \
	-D'coral="\#dd583d"' \
	-D'mediumblue="\#1d3d66"'
match=^\(^\s*\)\(\w\+\)\s*\[\s*label\s*=\s*"\(.*\)"\s*\]$$
svg=\1\2 [id="\2", label="{ ?? \| \3 }", shape=record]
map=\1\2 [URL="javascript:void 0;", id="\2", label="{ ?? \| \3 }", shape=record]
set=<input name="\2" type="checkbox" value="checked" />
bag=array_push($$GLOBALS["topics"], "\2");

build: topics.php

clean:
	$(RM) topics.dotx topics.cmapx topics.csetx topics.cbagx
	$(RM) topics.php topics.svg void.png
	$(RM) topics.data

deploy:
	echo rsync -avz topics.php topics.svg void.png server:html/

topics.dotx: topics.dot
	$(CPP) $(CPPFLAGS) -o$@ $<

topics.cmapx: topics.dotx
	sed 's|$(match)|$(map)|' $< | $(DOT) $(DOTFLAGS) -Tcmapx -o$@

topics.csetx: topics.dotx
	sed -n 's|$(match)|$(set)|p' $< > $@

topics.cbagx: topics.dotx
	sed -n 's|$(match)|$(bag)|p' $< > $@

topics.php: topics.html topics.svg
	$(CPP) $(CPPFLAGS) -o$@ $<

topics.svg: topics.dotx
	sed 's|$(match)|$(svg)|' $< | $(DOT) $(DOTFLAGS) -Tsvg -o$@

void.png:
	echo iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1H \
	AwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASU \
	VORK5CYII= | base64 --decode --ignore-garbage > $@

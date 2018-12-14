DOT=dot
DOTFLAGS=-Gfontname=sans -Nfontname=sans -Gfontsize=12 -Nfontsize=10
CPP=gcc
white="\#ffffff"
blue="\#1d3d66"
orange="\#dd583d"
gold="\#be9a54"
silver="\#cacac7"
CPPFLAGS=-C -E -P -nostdinc -w -xc \
	-D'whitesmoke=$(white)' -D'darkslateblue=$(blue)' -D'snow=$(white)' -D'ghostwhite=$(white)' \
	-D'lightgray=$(silver)' -D'midnightblue=$(blue)' -D'darkslategray=$(blue)' \
	-D'tomato=$(orange)' -D'aliceblue=$(white)' -D'mediumblue=$(blue)' \
	-D'orangered=$(orange)' -D'indianred=$(orange)' \
	-D'darkblue=$(blue)'
match=^\(^\s*\)\(\w\+\)\s*\[\s*label\s*=\s*"\(.*\)"\s*\]$$
svg=\1\2 [id="\2", label="{ ?? \| \3 }", shape=record]
map=\1\2 [URL="javascript:void 0;", id="\2", label="{ ?? \| \3 }", shape=record]
set=\1<input name="\2" type="checkbox" value="checked" />
bag=\1array_push($$GLOBALS["topics"], "\2");

build: topics.php

clean:
	$(RM) topics.dotx topics.cmapx topics.csetx topics.cbagx
	$(RM) topics.php topics.svg void.png
	$(RM) topics.data

deploy:
	@echo rsync -avz topics.php topics.svg void.png server:html/

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

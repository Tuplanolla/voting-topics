DOT=dot
DOTFLAGS=-Gfontname=sans -Nfontname=sans -Gfontsize=12 -Nfontsize=10
CPP=gcc
CPPFLAGS=-C -E -P -nostdinc -w -xc
match=^\s*\(\w\+\)\s*\[\s*label\s*=\s*"\(.*\)"\s*\]$$
svg=\1 [id="\1", label="{ ?? \| \2 }", shape=record]
map=\1 [URL="javascript:void 0;", id="\1", label="{ ?? \| \2 }", shape=record]
remove=title\s*=\s*"{.*}"
set=<input name="\1" type="checkbox" value="checked" />
bag=array_push($$GLOBALS["topics"], "\1");

build:
	echo iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII= | \
		base64 --decode > void.png
	sed 's|$(match)|$(svg)|' topics.dot | \
		$(DOT) $(DOTFLAGS) -Tsvg -otopics.svg
	sed 's|$(match)|$(map)|' topics.dot | \
		$(DOT) $(DOTFLAGS) -Tcmapx | \
		sed 's|$(remove)||' > topics.cmapx
	sed -n 's|$(match)|$(set)|p' topics.dot > topics.csetx
	sed -n 's|$(match)|$(bag)|p' topics.dot > topics.cbagx
	$(CPP) $(CPPFLAGS) -otopics.php topics.template

clean:
	$(RM) void.png topics.svg topics.cmapx topics.csetx topics.cbagx topics.php
	$(RM) topics.data

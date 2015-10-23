DOT=dot
DOTFLAGS=-Gfontname=sans -Nfontname=sans -Gfontsize=12 -Nfontsize=10
CPP=gcc
CPPFLAGS=-C -E -P -nostdinc -w -xc
match=^\(\s*\)\(\w\+\)\(\s*\)$$
svg=\1\2\3 [id="\2"]
map=\1\2\3 [URL="javascript:void(0);" id="\2"]
set=<input name="\2" type="checkbox" value="checked" />
bag=$$GLOBALS["topics"]["\2"] = false;

build:
	echo iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII= | base64 --decode > void.png
	sed 's|$(match)|$(svg)|' topics.dot | $(DOT) $(DOTFLAGS) -Tsvg -otopics.svg
	sed 's|$(match)|$(map)|' topics.dot | $(DOT) $(DOTFLAGS) -Tcmapx -otopics.cmapx
	sed -n 's|$(match)|$(set)|p' topics.dot > topics.csetx
	sed -n 's|$(match)|$(bag)|p' topics.dot > topics.cbagx
	$(CPP) $(CPPFLAGS) -otopics.php topics.template

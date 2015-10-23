#! /bin/sh

tac topics.data | sort -fsuk 3,3 | cut -d ' ' -f 4- | tr ' ' '\n' | sort | uniq -c | sort -nr

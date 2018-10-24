#!/bin/bash
# note exlicit generated window geometry hard-coded. to fix.
mkdir -p tools-out
git diff $1 > tools-out/fullgitdiff
git diff $1 | pcregrep -M -n '(\/\/\/|\/\*!.*\n(\+ \*.*\n)*|\/\*\*.*\*/)' | grep "+" > tools-out/new_dox
xfce4-terminal --geometry 80x82+0+0 --hide-scrollbar --hide-toolbar --hide-borders --hide-menubar --working-directory=`pwd` --zoom=-1 -x emacs -nw ./tools-out/new_dox

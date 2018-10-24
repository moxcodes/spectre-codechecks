#!/bin/bash
git diff $1 | pcregrep -M -n --colour "\)( \n*):[^({|}|:|;|except)]*{|[^(for( |\n)*|switch( |\n)*|while( |\n)*|if( |\n)*|CASE( |\n))](\((?:[^(\(\))|@@]++|(?1))*\))( |\n)*{" > tools-out/missing-noexcept
MISSING_NOEXCEPT_CHECK=$(cat tools-out/missing-noexcept)
if [ "$MISSING_NOEXCEPT_CHECK" != "" ]; then
   xfce4-terminal --geometry 80x82+1200+0 --hide-scrollbar --hide-toolbar --hide-borders --hide-menubar --working-directory=`pwd` --zoom=-1 -x emacs -nw ./tools-out/missing-noexcept
fi

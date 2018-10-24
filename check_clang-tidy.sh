#!/bin/bash
TOOLS_DIR=$1
FULL_BUILD_DIR=$2
CONTAINER=$3

cp $TOOLS_DIR/containers/run_clang-tidy.sh $FULL_BUILD_DIR/
sudo docker exec -w $FULL_BUILD_DIR $CONTAINER ./run_clang-tidy.sh
CLANGTIDY_CHECK=$(cat tools-out/clang-tidy-out | grep "warning")
if [ "$CLANGTIDY_CHECK" != "" ]
then
    xfce4-terminal --geometry 80x82+1200+0 --hide-scrollbar --hide-toolbar --hide-borders --hide-menubar --working-directory=`pwd` --zoom=-1 -x emacs -nw ./tools-out/clang-tidy-out
fi

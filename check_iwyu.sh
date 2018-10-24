#!/bin/bash
TOOLS_DIR=$1
FULL_BUILD_DIR=$2
CONTAINER=$3

cp $TOOLS_DIR/containers/run_iwyu.sh $FULL_BUILD_DIR/
sudo docker exec -w $FULL_BUILD_DIR $CONTAINER ./run_iwyu.sh
IWYU_CHECK=$(cat tools-out/iwyu | grep "should")
if [ "$IWYU_CHECK" != "" ]
then
    xfce4-terminal --geometry 80x82+600+0 --hide-scrollbar --hide-toolbar --hide-borders --hide-menubar --working-directory=`pwd` --zoom=-1 -x emacs -nw ./tools-out/iwyu
fi


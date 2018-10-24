#!/bin/bash
# for now assumes that project root is one directory up from BUILD_DIR
# need .bashrc usable by scripts to build, so need to do dumb sed stuff.
BUILD_DIR=`pwd`
cd ..
PROJECT_ROOT=`pwd`
cd $BUILD_DIR
echo "$PROJECT_ROOT"
source /etc/profile
sed -i "s/\[ \-z \"\$PS1\" \]/#\[ -z \"\$PS1\" \]/" /root/.bashrc
source /root/.bashrc
cd "$BUILD_DIR"
ctest > tools-out/ctest-out

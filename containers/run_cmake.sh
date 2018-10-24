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
# only compiling clang for now
cmake -D CHARM_ROOT=/work/charm/multicore-linux64-clang -D CMAKE_CXX_COMPILER=/usr/bin/clang++-5.0 -D USE_PCH=OFF $PROJECT_ROOT

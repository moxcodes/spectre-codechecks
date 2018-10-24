#!/bin/bash
# for now assumes that project root is one directory up from BUILD_DIR
BUILD_DIR=`pwd`
cd ..
PROJECT_ROOT=`pwd`
cd $BUILD_DIR
echo "$PROJECT_ROOT"
source /etc/profile
sed -i "s/\[ \-z \"\$PS1\" \]/#\[ -z \"\$PS1\" \]/" /root/.bashrc
source /root/.bashrc
cd "$BUILD_DIR"
make doc | grep "warn" > tools-out/dox-warnings

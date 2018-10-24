#!/bin/bash
BUILD_DIR=/home/mox/research/SXS/spectre-codereview
TOOLS_DIR=/home/mox/tools/scripts/development/spectre-codechecks/


cd $BUILD_DIR

mkdir -p "spectre-$1"
cd "spectre-$1"

git clone git@github.com:$1/spectre.git

cd spectre
git pull $2
git checkout $2
mkdir spectre-build
FULL_BUILD_DIR=$BUILD_DIR"/spectre-$1/spectre/spectre-build"

# make a new docker container for the code review
CONTAINER=`sudo docker run -v /var/run/docker.sock:/var/run/docker.sock -v $BUILD_DIR:$BUILD_DIR -h spectre-codereview-$1-$2 --security-opt seccomp=unconfined -i -t -d sxscollaboration/spectrebuildenv:latest`

BRANCHPOINT=`$TOOLS_DIR/git-branchpoint.sh`
echo "$BRANCHPOINT"
echo "$CONTAINER"
# run the cmake in the container - need to wait on the conclusion
cd $FULL_BUILD_DIR
cp $TOOLS_DIR/containers/run_cmake.sh $FULL_BUILD_DIR/
sudo docker exec -w $FULL_BUILD_DIR $CONTAINER ./run_cmake.sh

# run the documentation generation - wait for completion
cp $TOOLS_DIR/containers/make_doc.sh $FULL_BUILD_DIR/
mkdir tools-out
sudo docker exec -w $FULL_BUILD_DIR $CONTAINER ./make_doc.sh
# generate the 'just doc' file and bring up emacs for ispelling
$TOOLS_DIR/print_newdocs.sh $BRANCHPOINT
# bring up the documentation in a new chrome window
google-chrome-stable --new-window $FULL_BUILD_DIR/docs/html/index.html
# make
cp $TOOLS_DIR/containers/make.sh $FULL_BUILD_DIR/
sudo docker exec -w $FULL_BUILD_DIR $CONTAINER ./make.sh
# run the local code checking suite
$TOOLS_DIR/check_tests.sh $TOOLS_DIR $FULL_BUILD_DIR $CONTAINER &
$TOOLS_DIR/check_iwyu.sh $TOOLS_DIR $FULL_BUILD_DIR $CONTAINER &
$TOOLS_DIR/check_clang-tidy.sh $TOOLS_DIR $FULL_BUILD_DIR $CONTAINER &
$TOOLS_DIR/detect_missing_noexcept.sh $BRANCHPOINT 

# run git-clang-format, diff it, then reset
sudo docker exec -w $FULL_BUILD_DIR $CONTAINER ./run_clang_format.sh
git diff > tools-out/gitdiff-clangformat
git reset --hard

# destroy the docker
docker stop $CONTAINER
docker rm -v $CONTAINER

echo "Job's finished!"

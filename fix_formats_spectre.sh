#!/bin/bash
DEVELOP_ROOT=/home/mox/research/SXS/spectre/
BUILD_DIR=/home/mox/research/SXS/spectre/spectre-build/
GIT_OWNER=1000
GIT_GROUP=989

cd $BUILD_DIR
cmake -D CHARM_ROOT=/work/charm/multicore-linux64-clang -D CMAKE_CXX_COMPILER=/usr/bin/clang++-5.0 -D USE_PCH=OFF $DEVELOP_ROOT
make clean
make git-clang-format
cd $DEVELOP_ROOT
chown -R 1000:989 src*
chown -R 1000:989 test*
chown -R 1000:989 .git*
cd $BUILD_DIR
make -j50
cd $DEVELOP_ROOT
if [ "$2" == "format-hard" ]; then
    echo "formatting hard. Check the diffs to make sure you're not pissing off your code reviewers."
    git diff --name-only develop | xargs -I% clang-format -i %
fi
git diff > /tmp/gitdiff-clangformat
echo "Running tests... Be patient, these take a while. (output in /tmp/ctest_out)"
cd $BUILD_DIR
ctest > /tmp/ctest_out
CTEST_CHECK=$(cat /tmp/ctest_out | grep "Other")
if [ "$CTEST_CHECK" != "" ]; then
    echo "Code fails tests! What are you even trying to push?"
    exit
fi
echo "tests passed."

echo "Checking includes (output in /tmp/iwyu)"
git diff --name-only develop | xargs -I% make iwyu FILE=../% > /tmp/iwyu
IWYU_CHECK=$(cat /tmp/iwyu | grep should)
if [ "$IWYU_CHECK" != "" ]; then
    echo "Includes are not what you use! use(lib) if and only if include(lib)."
    exit
fi
echo "includes are appropriate."

echo "checking clang-tidy. (output in /tmp/clang-tidy/out)"
git diff --name-only develop | grep cpp | xargs -I% make clang-tidy FILE=../% > /tmp/clang-tidy-out
CLANGTIDY_CHECK=$(cat /tmp/clang-tidy-out | grep warning)
if [ "$CLANGTIDY_CHECK" != "" ]; then
    echo "Code is not clang-tidy! You can't go out looking like that."
    exit
fi
echo "Alright. Code looks good, let's go."

git diff  develop | grep -E "^\+//|^\+ \* " > comments
echo "Comments placed in $BUILD_DIR/comments. Check for spelling before pushing."
echo "no pcregrep present on docker - run noexcept finder separately."
cd $DEVELOP_ROOT
if [ $1 -gt "0" ]; then
    git rebase -i HEAD~$1
fi
chown -R $GIT_OWNER:$GIT_GROUP src*
chown -R $GIT_OWNER:$GIT_GROUP test*
chown -R $GIT_OWNER:$GIT_GROUP .git*
echo "Alright, check out the results. Want to push? Y/n"
select yn in "y" "n"
do
    echo $yn
    case $yn in
	"y")
	    echo "push drill, not actually pushing though..."; exit;;
	"n")
	    echo "not pushing. exiting"; exit;;
	*)
	    echo "no parse correct";
    esac
done

# select yn in "y" "n"; do
#     case $yn in
# 	y ) git push origin HEAD -f; break;;
# 	n ) echo "not pushing. exiting"; exit;;
#     esac
# done
# done

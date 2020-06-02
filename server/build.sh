#!/bin/bash

# We want to fail on bad exit codes
set -e

BASEDIR=$(dirname $(readlink -f $0))
echo ""
echo " ----------------------------------"
echo "| Ensuring a clean build directory |"
echo " ----------------------------------"
echo ""
echo "Directory: $BASEDIR/build/"
cd $BASEDIR
rm -rf build
mkdir build
cd build
echo "DONE"

echo ""
echo " -------------------"
echo "| Downloading Pharo |"
echo " -------------------"
echo ""
curl https://get.pharo.org/64/80+vm | bash

echo ""
echo " -------------------------------"
echo "| Loading code and dependencies |"
echo " -------------------------------"
echo ""
REPO="tonel://$BASEDIR/src"
echo "Repository: $REPO"
echo ""
./pharo Pharo.image metacello install $REPO BaselineOfMenta

echo ""
echo " -------------------------"
echo "| Build Finished: SUCCESS |"
echo " -------------------------"
echo ""
exit 0

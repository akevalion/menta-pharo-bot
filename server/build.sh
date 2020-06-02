#!/bin/bash

# We want to fail on bad exit codes
set -e

BASEDIR=$(pwd)
REPO="tonel://$BASEDIR/src"

echo ""
echo " ---------------------------------"
echo "| Ensure a clean build/ directory |"
echo " ---------------------------------"
echo ""
rm -rf build
mkdir build
cd build

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
./pharo Pharo.image metacello install $REPO BaselineOfMenta

echo ""
echo " -------------------------"
echo "| Build Finished: SUCCESS |"
echo " -------------------------"
echo ""
echo "Run './start.sh' to start the server."
exit 0

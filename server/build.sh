#!/bin/bash

# See what is executed and fail on bad exit codes
set -ex

BASEDIR=$(pwd)
REPO="filetree://$BASEDIR/src"

# ensure a clean build directory
rm -rf build
mkdir build
cd build

# download image and vm
curl get.pharo.org/70+vm | bash

# load code
./pharo Pharo.image metacello install $REPO BaselineOfMenta

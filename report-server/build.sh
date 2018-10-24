#!/bin/bash

# See what is executed and fail on bad exit codes
set -ex

mkdir build
cd build

# download image and vm
curl get.pharo.org/70+vm | bash

REPO="filetree://src"
./pharo Pharo.image metacello install $REPO BaselineOfMenta #--install=development
#./pharo Pharo.image eval --save '(IceRepositoryCreator new repository: nil; location: FileSystem workingDirectory; createRepository) register'
#./pharo Pharo.image eval --save "Gofer it smalltalkhubUser: 'zeroflag' project: 'Teapot'; configuration; loadStable"

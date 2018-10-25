#!/bin/bash

# See what is executed and fail on bad exit codes
set -ex

cd report-server
./build.sh
cd ..
npm install

printf "\n\nBuild all: SUCCESS\n"

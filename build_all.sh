#!/bin/bash

# See what is executed and fail on bad exit codes
set -ex

cd report-server
./build.sh
cd ..

cd probot-server
npm install
cd ..

printf "\n\nBuild all: SUCCESS\n"

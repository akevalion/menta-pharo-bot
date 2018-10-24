#!/bin/bash

# See what is executed and fail on bad exit codes
set -ex

cd report-server
./build.sh
cd ..
npm install

echo "Build SUCCESS"
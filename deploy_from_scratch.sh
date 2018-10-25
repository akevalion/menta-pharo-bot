#!/bin/bash

SSH_TARGET=mdias@huelmo.dcc.uchile.cl

ssh $SSH_TARGET /bin/bash << EOF
set -ex

./screen_stop_all.sh

# DESTRUCTIVE!
rm -rf menta-pharo-bot

git clone https://github.com/tinchodias/menta-pharo-bot.git --depth=1

cd menta-pharo-bot
./build_all.sh
./screen_start_all.sh
EOF

#!/bin/bash

# See what is executed and fail on bad exit codes
set -ex

SSH_TARGET=mdias@huelmo.dcc.uchile.cl

ssh $SSH_TARGET /bin/bash << EOF
set -ex

rm -rf menta-pharo-bot-master

curl -SLO https://github.com/tinchodias/menta-pharo-bot/archive/master.zip
unzip master.zip
rm master.zip

# TODO: use https?
#git clone git@github.com:tinchodias/menta-pharo-bot.git --depth=1

cd menta-pharo-bot-master
./build_all.sh
#./start_all.sh
EOF

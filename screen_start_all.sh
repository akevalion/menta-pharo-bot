#!/bin/bash

cd report-server
screen -dmS report-server "./start.sh"
cd ..

cd probot-server
screen -dmS probot-server "./start.sh"
cd ..

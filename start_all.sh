#!/bin/bash

screen -S report-server "./report-server/start.sh"
screen -S probot-server "npm start"
echo "Start SUCCESS"
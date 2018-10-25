#!/bin/bash

screen -dmS probot-server "./start.sh"

cd report-server
screen -dmS report-server "./start.sh"

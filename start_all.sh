#!/bin/bash

screen -S report-server "./report-server/start.sh"
screen -S probot-server "./start.sh"

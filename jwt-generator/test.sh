#!/bin/bash

TOKEN=`node index.js`
curl -v -i \
    -H "Authorization: Bearer $TOKEN" \
    -H "Accept: application/vnd.github.machine-man-preview+json" \
    -H "User-Agent: menta-pharo-bot" \
    https://api.github.com/app

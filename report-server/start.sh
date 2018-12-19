#!/bin/bash

./build/pharo build/Pharo.image eval --no-quit "(MeEasy readFromStonFileAt: Menta repositoryPath / 'MeDemoApp.ston') start"

#!/bin/bash

./build/pharo build/Pharo.image eval --no-quit "\
MeDemo new\
	basePublicUrl: 'http://gate.dcc.uchile.cl:3000/public/';\
	basePublicPath: (FileLocator imageDirectory parent parent / 'public') asPath;\
	start"

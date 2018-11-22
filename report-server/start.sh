#!/bin/bash

./build/pharo build/Pharo.image eval --no-quit "\
MeDemo new\
	publicFiles: (MePublicFiles new\
		url: 'http://gate.dcc.uchile.cl:3000/public/';\
		path: (FileLocator imageDirectory parent parent / 'public') asPath;\
		yourself);\
	start."

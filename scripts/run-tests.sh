#!/bin/bash 

set -ex

wget --quiet -O - get.pharo.org/alpha+vm | bash

./pharo Pharo.image eval --save "
Metacello new 
	baseline: 'FFICHeaderExtractor';
	repository: 'filetree://repository';
	load.
	
	Gofer it
		url: 'http://smalltalkhub.com/mc/marianopeck/MarianoPublic/main';
		package: 'SUnit-UI';
	load.	
"

./pharo Pharo.image test --fail-on-failure "FFICHeaderExtractor.*" 2>&1

if [ -s PharoDebug.log ]; then cat PharoDebug.log; fi
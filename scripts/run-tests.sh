#!/bin/bash 

set -ex

wget --quiet -O - get.pharo.org/alpha+vm | bash

./pharo Pharo.image eval --save "

Author fullName: 'Travis'.

Metacello new 
	baseline: 'FFICHeaderExtractor';
	repository: 'filetree://repository';
	load.
	
	Gofer it
		url: 'http://smalltalkhub.com/mc/marianopeck/MarianoPublic/main';
		package: 'SUnit-UI';
	load.	
"

./pharo Pharo.image test --no-xterm --fail-on-failure "FFICHeaderExtractor.*" 2>&1
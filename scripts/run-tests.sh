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

error=`./pharo Pharo.image test --fail-on-failure "FFICHeaderExtractor.*" 2>&1`
log=PharoDebug.log

	
if [  -f "$log" ]; then
	echo "PharoDebug.log exists"
	cat PharoDebug.log
else
	echo "PharoDebug.log does NOT exist"
fi

echo "Pharo exit code was: $error"
exit $error
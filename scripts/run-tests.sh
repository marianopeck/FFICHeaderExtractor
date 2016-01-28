#!/bin/bash 

set -ex

wget --quiet -O - get.pharo.org/alpha+vm | bash

./pharo Pharo.image eval --save "

Metacello new 
	baseline: 'FFICHeaderExtractor';
	repository: 'filetree://repository';
	load.
	
"

./pharo Pharo.image test --no-xterm --fail-on-failure "FFICHeaderExtractor.*" 2>&1
running C program
runCProgram
	| runCStream | 
	runCStream := String new writeStream.
	runCStream nextPutAll: 'cd ', FileSystem workingDirectory fullName, '; '.
	runCStream nextPutAll: './', '"', self binaryFilename, '"'.
	runCStream nextPutAll: ' >> '.
	runCStream nextPutAll: '"', self logFilename, '"'.
	runCStream nextPutAll: ' 2>&1 '.
	Transcript show: 'Execute C program string: ', runCStream contents; cr.
	self system: runCStream contents.
	
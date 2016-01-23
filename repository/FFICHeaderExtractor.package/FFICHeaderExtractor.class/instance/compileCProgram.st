running C program
compileCProgram
	| compileScriptStream | 
	compileScriptStream := String new writeStream.
	compileScriptStream nextPutAll: 'cd ', FileSystem workingDirectory fullName, '; '.
	compileScriptStream nextPutAll: self compiler.
	compileScriptStream nextPutAll: ' '.
	compileScriptStream nextPutAll: self cFlags.
	compileScriptStream nextPutAll: ' -o '.
	compileScriptStream nextPutAll: '"', self binaryFilename, '"'.
	compileScriptStream nextPutAll: ' '.
	compileScriptStream nextPutAll: '"', self cProgramFilename, '"'.
	compileScriptStream nextPutAll: ' > '.
	compileScriptStream nextPutAll: '"', self logFilename, '"'.
	compileScriptStream nextPutAll: ' 2>&1 '.
	Transcript show: 'Compile string: ', compileScriptStream contents; cr.
	self system: compileScriptStream contents.
	
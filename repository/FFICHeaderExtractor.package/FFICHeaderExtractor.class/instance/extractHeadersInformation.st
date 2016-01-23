extracting
extractHeadersInformation
	| log |
	[
	self 
		generateCProgram;
		compileCProgram;
		runCProgram.
	] on: Error do: [ :ex | 
		self error: 'Error: ', ex printString. '. You may want to check ', self logFilename
	].
	log := self logFilename asFileReference readStream contents.
	log ifNotEmpty: [ 
		log inspect.
		self error: 'There was a problem in the autogeneration. You may want to check ', self logFilename
		 ].
	
	

generating
autogenerateForCurrentPlatform
	| extractor log |
	extractor := Smalltalk os preprocessorExtractorFor: self.
	[
	extractor 
		generateCProgram;
		compileCProgram;
		runCProgram.
	] on: Error do: [ :ex | 
		self error: 'Error: ', ex printString. '. You may want to check ', extractor logFilename
	].
	log := extractor logFilename asFileReference readStream contents.
	log ifNotEmpty: [ 
		log inspect.
		self error: 'There was a problem in the autogeneration. You may want to check ', extractor logFilename
		 ]
	
	

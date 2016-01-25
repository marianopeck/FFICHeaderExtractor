platforms
unix32

	^ FFICHeaderExtractor new
		sharedPool: self;
		platformName: 'unix'; "Should match with 'Smalltalk os platformName ' "
		wordSize: 32;
		cFlags: '-m32';
		headersToInclude: self headersContainingVariables;
		compiler: 'gcc';
		yourself
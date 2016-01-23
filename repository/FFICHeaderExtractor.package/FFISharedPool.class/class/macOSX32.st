platforms
macOSX32

	^ FFICHeaderExtractor new
		sharedPool: self;
		platformName: 'Mac OS'; "Should match with 'Smalltalk os platformName ' "
		wordSize: 32;
		cFlags: '-m32';
		headersToInclude: self headersContainingVariables;
		compiler: 'cc';
		yourself
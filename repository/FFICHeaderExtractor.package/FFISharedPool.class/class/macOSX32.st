platforms
macOSX32

	^ FFIPreprocessorExtractor new
		sharedPool: self;
		platformName: 'Mac OS'; "Should match with 'Smalltalk os platformName ' "
		wordSize: 4;
		cFlags: '-m32';
		headersToInclude: self headersContainingVariables;
		compiler: 'cc';
		yourself
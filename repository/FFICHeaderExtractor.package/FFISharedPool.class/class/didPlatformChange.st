testing
didPlatformChange
	^ ((self platformName = self currentPlatformName) and: [ self wordSize = self currentWordSize ]) not 
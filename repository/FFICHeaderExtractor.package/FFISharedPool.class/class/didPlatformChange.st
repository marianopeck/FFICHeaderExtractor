testing
didPlatformChange
	^ ((self platformName = Smalltalk os platformName) and: [ self wordSize = (FFIExternalType sizeOf: #int) ]) not 
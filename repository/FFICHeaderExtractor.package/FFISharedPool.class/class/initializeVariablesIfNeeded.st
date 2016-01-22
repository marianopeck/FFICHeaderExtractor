initialization
initializeVariablesIfNeeded
	self shouldInitializeVariables ifTrue: [ 
		self nilAllClassVars.
		self initializeVariablesFromExtracted.
		self updatePlatformInfo. 
	]
	
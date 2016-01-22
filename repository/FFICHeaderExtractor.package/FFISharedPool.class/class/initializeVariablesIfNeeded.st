initialization
initializeVariablesIfNeeded
	self shouldInitializeVariables ifTrue: [ self initializeVariablesFromExtracted  ]
	
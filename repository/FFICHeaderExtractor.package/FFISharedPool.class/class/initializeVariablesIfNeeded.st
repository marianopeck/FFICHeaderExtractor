initialization
initializeVariablesIfNeeded
	| selector | 
	self shouldInitializeVariables ifTrue: [ 
		selector := self lookupInitMethodForCurrentPlatform.
		selector ifNotNil: [ 
			self nilAllClassVars.
			self initializeVariablesFrom: selector.
			self updatePlatformInfo.
		] 
	]
	
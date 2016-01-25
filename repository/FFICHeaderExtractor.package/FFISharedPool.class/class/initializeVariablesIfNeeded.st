variables initialization
initializeVariablesIfNeeded
	| selector | 
	self shouldInitializeVariables ifTrue: [ 
		selector := self lookupInitMethodForCurrentPlatform.
		selector ifNotNil: [ 
			self initializeVariablesFrom: selector.
			self updatePlatformInfo.
		] 
	]
	
variables initialization
initializeVariablesFrom: aSelector
	aSelector ifNotNil: [ self perform: aSelector. ]
	
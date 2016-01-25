tests
testInitializeVariablesWithNoMethodFound
	self testingSharedPool reset.
	self testingSharedPool removeAllGeneratedMethods.
	self testingSharedPool classVarNamed: 'SIGKILL' put: 42.
	self assert: self testingSharedPool shouldInitializeVariables.
	self testingSharedPool initializeVariablesIfNeeded.
	self assert: self testingSharedPool platformName isNil.
	self assert: self testingSharedPool wordSize isNil.
	self assert: (self testingSharedPool classVarNamed: 'SIGKILL') equals: 42.
	self assert: (self testingSharedPool classVarNamed: 'EINVAL') isNil.
		


	
	
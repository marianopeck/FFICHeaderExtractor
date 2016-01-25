tests
testResetAndTestingMethods
	self testingSharedPool classVarNamed: 'SIGKILL' put: 9.
	self testingSharedPool reset. 
	self assert: (self testingSharedPool classVarNamed: 'SIGKILL') isNil.
	self assert: self testingSharedPool platformName isNil.
	self assert: self testingSharedPool wordSize isNil.
	self deny: self testingSharedPool hasAlreadyBeenInitializedBefore.
	self assert: self testingSharedPool shouldInitializeVariables.
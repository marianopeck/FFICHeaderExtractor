initialization
allSubclassesInitializeVariablesFromExtracted
	self allSubclassesDo: [ :each | each initializeVariablesFromExtracted ]
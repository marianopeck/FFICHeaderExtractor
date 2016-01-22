system startup
startUp: resuming
	
	resuming ifTrue: [ 
		self allSubclassesDo: [ :each | each initializeVariablesIfNeeded ]	
	]
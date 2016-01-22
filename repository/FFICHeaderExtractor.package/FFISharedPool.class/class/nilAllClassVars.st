resetting
nilAllClassVars
	self classVarNames do: [ :each | 
		self classVarNamed: each put: nil ] 
	
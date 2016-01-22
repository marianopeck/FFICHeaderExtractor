generating C program
writeListOfConstantsOn: aStream
	
	self sharedPool classVarNames withIndexDo: [ :each :index |
		aStream nextPutAll: (('
	#ifdef <1s>
		printDefinedConstant(file, <1s>);
	#else
		printUndefinedConstant(file, <1s>);
	#endif') expandMacrosWith: each); cr
	].
	
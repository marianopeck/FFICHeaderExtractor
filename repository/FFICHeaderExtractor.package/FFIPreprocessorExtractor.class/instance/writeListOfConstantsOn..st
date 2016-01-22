generating C program
writeListOfConstantsOn: aStream
	aStream cr.
	aStream nextPutAll: 'void fillContantsArray() {'; cr.
	self sharedPool classVarNames withIndexDo: [ :each :index |
		aStream nextPutAll: (('
 	#ifdef <1s>
        constants[<2s>].value = <1s>;
        constants[<2s>].name = "<1s>";
		  constants[<2s>].defined = 1;
  	#else
        constants[<2s>].name = "<1s>";
   #endif') expandMacrosWith: each with: (index -1) asString ); cr
	].
	aStream nextPutAll: '}'; cr.
	
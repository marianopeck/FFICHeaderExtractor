generating C program
generateCProgram
	| stream | 
	stream := StandardFileStream forceNewFileNamed: self cProgramFilename "'/Users/mariano/prueba.c'".
	self writeCMainCommentOn: stream.
	self writePlatformInfoOn: stream.
	self writeCIncludesOn: stream.
	self writeConstantsArrayOn: stream.
	self writeListOfConstantsOn: stream.
	self writeRestOfCFileOn: stream.
	stream flush; close.
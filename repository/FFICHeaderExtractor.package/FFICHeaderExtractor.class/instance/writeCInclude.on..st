generating C program
writeCInclude: aHeaderName on: aStream
	aStream nextPutAll: '#include <', aHeaderName, '>'; cr.	

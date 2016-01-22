generating C program
writeCIncludesOn: stream
	self writeCIncludes: #('stdio.h' 'stdlib.h' 'string.h') on: stream.
	self writeCIncludes: self headersToInclude on: stream.
	stream cr.
	
	

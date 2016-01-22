generating C program
writeCIncludes: aListOfHeaderNames on: stream
	aListOfHeaderNames do: [ :each | self writeCInclude: each on: stream ]

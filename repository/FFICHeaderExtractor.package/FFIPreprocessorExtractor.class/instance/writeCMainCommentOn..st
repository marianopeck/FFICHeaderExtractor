generating C program
writeCMainCommentOn: stream
	stream nextPutAll: ('//
//
//  Program automatically generated on <1s>
//
//
'	expandMacrosWith: Date today yyyymmdd ).
	stream cr.
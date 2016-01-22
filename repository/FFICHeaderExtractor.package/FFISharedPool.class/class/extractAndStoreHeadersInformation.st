extracting
extractAndStoreHeadersInformation
	| extractor |
	extractor := self extractHeadersInformation.
	self storeFromExtracted: extractor 
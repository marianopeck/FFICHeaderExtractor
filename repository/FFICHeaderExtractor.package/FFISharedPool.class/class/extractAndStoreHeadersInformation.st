extracting
extractAndStoreHeadersInformation
	| extractor |
	extractor := Smalltalk os preprocessorExtractorFor: self.
	extractor extractAndStoreHeadersInformation.
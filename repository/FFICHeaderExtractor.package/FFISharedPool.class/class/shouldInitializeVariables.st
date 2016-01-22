testing
shouldInitializeVariables
	^ self hasAlreadyBeenInitializedBefore not or: [ self didPlatformChange ]
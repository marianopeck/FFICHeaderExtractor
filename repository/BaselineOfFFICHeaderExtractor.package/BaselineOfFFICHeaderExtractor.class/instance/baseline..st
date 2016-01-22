baseline
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ 
			spec
				package: 'FFICHeaderExtractor'
				"package: 'FFICHeaderExtractor-Tests' with: [ spec requires: 'FFICHeaderExtractor' ]"
				]
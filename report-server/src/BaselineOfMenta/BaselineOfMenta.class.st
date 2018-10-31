Class {
	#name : #BaselineOfMenta,
	#superclass : #BaselineOf,
	#category : #BaselineOfMenta
}

{ #category : #baselines }
BaselineOfMenta >> baseline: spec [
	<baseline>
	spec
		for: #pharo
		do: [ 
			spec
				project: 'Teapot'
				with: [ 
					spec
						className: #ConfigurationOfTeapot;
						versionString: '2.5';
						repository: 'http://smalltalkhub.com/mc/zeroflag/Teapot/main' ].

			spec
				baseline: 'Roassal2' 
				with: [
					spec repository: 'github://ObjectProfile/Roassal2:45a5c24cc6ad5a0c668c6c3063dcb4e6cba25c07/src' ].

			spec package: 'Menta' with: [ spec requires: #('Teapot' 'Roassal2') ].
			spec group: 'default' with: #('Menta')
			]
]

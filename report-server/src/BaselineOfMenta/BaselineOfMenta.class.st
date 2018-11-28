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
			self
				teapot: spec;
				roassal2: spec;
				osSubprocess: spec;
				rfb: spec.
			
			spec package: 'Menta' with: [ spec requires: #('Teapot' 'Roassal2' 'OSSubprocess' 'RFB') ].
			spec group: 'default' with: #('Menta')
			]
]

{ #category : #baselines }
BaselineOfMenta >> osSubprocess: spec [
	spec 
		baseline: 'OSSubprocess' 
		with: [ spec repository: 'github://pharo-contributions/OSSubprocess:v1.0.1/repository' ]

]

{ #category : #baselines }
BaselineOfMenta >> rfb: spec [
	spec
		project: 'RFB'
		with: [ spec
				className: #ConfigurationOfRFB;
				versionString: #stable;
				repository: 'http://smalltalkhub.com/mc/PharoExtras/RFB/main/' ]
]

{ #category : #baselines }
BaselineOfMenta >> roassal2: spec [
	spec
		baseline: 'Roassal2'
		with: [ spec repository: 'github://ObjectProfile/Roassal2:45a5c24cc6ad5a0c668c6c3063dcb4e6cba25c07/src' ]
]

{ #category : #baselines }
BaselineOfMenta >> teapot: spec [
	spec project: 'Teapot' with: [ spec repository: 'github://zeroflag/Teapot:v2.6.0/source' ]
]

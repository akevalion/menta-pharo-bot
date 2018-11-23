Extension { #name : #IceGitHubAPI }

{ #category : #'*Menta' }
IceGitHubAPI >> newRequestTo: aString [
	^ ZnClient new 
		in: [ :this | 
			isAnonymous ifFalse: [ 
				self credentials prepareRequest: this ] ];
		headerAt: 'Accept' put: 'application/vnd.github.v3+json';
		url: 'https://api.github.com/', (aString first = $/
			ifTrue: [ aString allButFirst ]
			ifFalse: [ aString ]);
		yourself
]

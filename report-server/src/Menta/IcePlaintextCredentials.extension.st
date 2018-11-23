Extension { #name : #IcePlaintextCredentials }

{ #category : #'*Menta' }
IcePlaintextCredentials >> prepareRequest: aZnClient [
	aZnClient username: self username password: self password
]

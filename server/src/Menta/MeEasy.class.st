"
I have utility methods to work with subclasses of MeGithubApp.
"
Class {
	#name : #MeEasy,
	#superclass : #Object,
	#category : #'Menta-Github App'
}

{ #category : #testing }
MeEasy class >> isMorphicUIManagerActive [
	 ^ UIManager default class isActiveManager
]

{ #category : #convenience }
MeEasy class >> readFromStonFileAt: aFileReference [
	^ aFileReference readStreamDo: [ :stream | STON fromStream: stream ]
]

{ #category : #convenience }
MeEasy class >> write: aMeGithubApp toStonFileAt: aFileReference [
	aFileReference writeStreamDo: [ :stream | STON put: aMeGithubApp onStreamPretty: stream ]
]

"
I have utility methods to work with subclasses of MeGithubApp.
"
Class {
	#name : #MeEasy,
	#superclass : #Object,
	#category : #'Menta-Github App'
}

{ #category : #convenience }
MeEasy class >> readFromStonFileAt: aFileReference [
	^ aFileReference readStreamDo: [ :stream | STON fromStream: stream ]
]

{ #category : #convenience }
MeEasy class >> write: aMeGithubApp toStonFileAt: aFileReference [
	aFileReference writeStreamDo: [ :stream | STON put: self onStreamPretty: stream ]
]

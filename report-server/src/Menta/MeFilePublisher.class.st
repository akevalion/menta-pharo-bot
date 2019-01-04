"
This represents an abstract method to publish files in a server and answer a public URL.

"
Class {
	#name : #MeFilePublisher,
	#superclass : #Object,
	#instVars : [
		'path',
		'url'
	],
	#category : #'Menta-Github App'
}

{ #category : #handling }
MeFilePublisher >> publishAtUniqueFileName: fileName do: aBlock [
	"Answer the url that corresponds to the fileName, after evaluating the aBlock with a FileReference where it may write contents."

	^ self subclassResponsibility
]

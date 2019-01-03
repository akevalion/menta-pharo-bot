"
This are the settings for the public files server of this App.

It includes: 
* path: the server-internal path to the directory that is exposed to the web
* url: the location of the exposed directory

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

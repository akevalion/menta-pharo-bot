"
This is a publish method that places the files in a local directory assuming there is an external static file server that allows the access to such files.

It includes: 
* path: the server-internal path to the directory that is exposed to the web
* url: the location of the exposed directory

"
Class {
	#name : #MeLocalFileServerPublisher,
	#superclass : #MeFilePublisher,
	#category : #'Menta-Github App'
}

{ #category : #accessing }
MeLocalFileServerPublisher >> path [
	^ path
]

{ #category : #accessing }
MeLocalFileServerPublisher >> path: anObject [
	path := anObject
]

{ #category : #accessing }
MeLocalFileServerPublisher >> pathFor: fileName [
	^ (path / fileName) canonicalize
]

{ #category : #handling }
MeLocalFileServerPublisher >> publishAtUniqueFileName: fileName do: aBlock [
	aBlock value: (self pathFor: fileName).
	^ self urlFor: fileName
]

{ #category : #accessing }
MeLocalFileServerPublisher >> url [
	^ url
]

{ #category : #accessing }
MeLocalFileServerPublisher >> url: anObject [
	url := anObject
]

{ #category : #accessing }
MeLocalFileServerPublisher >> urlFor: fileName [
	^ url, fileName asString
]

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
MeLocalFileServerPublisher >> path: aFileSystemPath [
	"Set the server's internal path to the directory that is exposed to the web.
	The file will be written there."
	
	path := aFileSystemPath
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
MeLocalFileServerPublisher >> url: aString [
	"Set the location of the exposed directory.
	
	The expected argument is a url represented as a String, which ends with slash. 
	For example, 'http://server.com:8080/public/'"

	url := aString
]

{ #category : #accessing }
MeLocalFileServerPublisher >> urlFor: fileName [
	^ url, fileName asString
]

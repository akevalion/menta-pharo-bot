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

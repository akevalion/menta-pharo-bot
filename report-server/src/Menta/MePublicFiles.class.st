Class {
	#name : #MePublicFiles,
	#superclass : #Object,
	#instVars : [
		'path',
		'url'
	],
	#category : #Menta
}

{ #category : #accessing }
MePublicFiles >> path [
	^ path
]

{ #category : #accessing }
MePublicFiles >> path: anObject [
	path := anObject
]

{ #category : #handling }
MePublicFiles >> pathFor: fileName [
	^ (path / fileName) canonicalize
]

{ #category : #accessing }
MePublicFiles >> url [
	^ url
]

{ #category : #accessing }
MePublicFiles >> url: anObject [
	url := anObject
]

{ #category : #handling }
MePublicFiles >> urlFor: fileName [
	^ url, fileName asString
]

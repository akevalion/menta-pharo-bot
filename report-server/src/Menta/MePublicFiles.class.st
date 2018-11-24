"
This are the settings for the public files server of this App.

It includes: 
* path: the server-internal path to the directory that is exposed to the web
* url: the location of the exposed directory

"
Class {
	#name : #MePublicFiles,
	#superclass : #Object,
	#instVars : [
		'path',
		'url'
	],
	#category : #'Menta-Server'
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

Class {
	#name : #MeLogger,
	#superclass : #Object,
	#instVars : [
		'writeStream',
		'semaphore'
	],
	#category : #Menta
}

{ #category : #initialization }
MeLogger >> initialize [

	super initialize.

	semaphore := Semaphore forMutualExclusion.
	writeStream := (Smalltalk session id asString36, '-', self identityHash printStringHex, '.log') asFileReference writeStream.
]

{ #category : #initialization }
MeLogger >> logError: anError [
	writeStream
		nextPutAll: anError messageText withUnixLineEndings;
		flush
]

{ #category : #accessing }
MeLogger >> semaphore [
	^ semaphore
]

{ #category : #accessing }
MeLogger >> writeStream [
	^ writeStream
]

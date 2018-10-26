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
	writeStream := Stdio stdout.
]

{ #category : #logging }
MeLogger >> log: aString kind: kind [
	writeStream
		print: DateAndTime now;
		nextPut: Character space;
		nextPut: Character tab;
		nextPutAll: kind;
		nextPut: Character space;
		nextPut: Character tab;
		nextPutAll: aString withUnixLineEndings;
		lf
]

{ #category : #logging }
MeLogger >> logError: anError [
	self log: anError messageText withUnixLineEndings kind: 'ERROR'
]

{ #category : #logging }
MeLogger >> logInfo: aString [
	self log: aString withUnixLineEndings kind: 'INFO'
]

{ #category : #logging }
MeLogger >> logTrace: aString [
	self log: aString withUnixLineEndings kind: 'TRACE'
]

{ #category : #accessing }
MeLogger >> semaphore [
	^ semaphore
]

{ #category : #accessing }
MeLogger >> writeStream [
	^ writeStream
]

{ #category : #accessing }
MeLogger >> writeStream: aWriteStream [
	writeStream := aWriteStream
]

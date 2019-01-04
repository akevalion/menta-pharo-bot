"
This is a simple logger that helps understanding a MeServer behavior.
"
Class {
	#name : #MeLogger,
	#superclass : #Object,
	#instVars : [
		'writeStream',
		'semaphore'
	],
	#classInstVars : [
		'current'
	],
	#category : #'Menta-Github App'
}

{ #category : #accessing }
MeLogger class >> current [
	^ current ifNil: [ current := self new ]
]

{ #category : #accessing }
MeLogger class >> reset [
	current := nil
]

{ #category : #initialization }
MeLogger >> initialize [
	super initialize.
	semaphore := Semaphore forMutualExclusion
]

{ #category : #logging }
MeLogger >> log: aString kind: kind [
	self writeStream
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
	^ writeStream ifNil: [ Stdio stdout ]
]

{ #category : #accessing }
MeLogger >> writeStream: aWriteStream [
	writeStream := aWriteStream
]

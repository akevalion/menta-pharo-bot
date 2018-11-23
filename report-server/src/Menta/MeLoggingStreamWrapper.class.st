Class {
	#name : #MeLoggingStreamWrapper,
	#superclass : #Object,
	#instVars : [
		'wrappedStream',
		'loggingStream'
	],
	#classVars : [
		'Log'
	],
	#category : #'Menta-Debug'
}

{ #category : #'as yet unclassified' }
MeLoggingStreamWrapper class >> install [
	"Hooks ZnRequest>>writeOn:
	Nothing fancy. To uninstall, revert manually using version tools."

	(ZnRequest sourceCodeAt: #writeOn:) = self znRequestWriteOnSourceCodeWithoutLogging 
		ifFalse: [ self error: 'Unknown Zinc method version' ]
		ifTrue: [ ZnRequest compile: self znRequestWriteOnSourceCodeWithLogging ]
]

{ #category : #'as yet unclassified' }
MeLoggingStreamWrapper class >> on: aZnBivalentWriteStream [ 
	^ self basicNew _on: aZnBivalentWriteStream; yourself
]

{ #category : #'as yet unclassified' }
MeLoggingStreamWrapper class >> znRequestWriteOnSourceCodeWithLogging [
	^ 'writeOn: stream
	| bivalentWriteStream |
	bivalentWriteStream := MeLoggingStreamWrapper on: (ZnBivalentWriteStream on: stream).
	self requestLine writeOn: bivalentWriteStream.
	super writeOn: bivalentWriteStream'
]

{ #category : #'as yet unclassified' }
MeLoggingStreamWrapper class >> znRequestWriteOnSourceCodeWithoutLogging [
	^ 'writeOn: stream
	| bivalentWriteStream |
	bivalentWriteStream := ZnBivalentWriteStream on: stream.
	self requestLine writeOn: bivalentWriteStream.
	super writeOn: bivalentWriteStream'
]

{ #category : #'as yet unclassified' }
MeLoggingStreamWrapper >> _loggingStream [
	^ Log ifNil: [
		Log := (ByteArray new: 10) writeStream inspect; yourself ]
]

{ #category : #'as yet unclassified' }
MeLoggingStreamWrapper >> _on: anObject [
	wrappedStream := anObject
]

{ #category : #'as yet unclassified' }
MeLoggingStreamWrapper >> doesNotUnderstand: aMessage [
	"To make sure that we can use accessors to access the dynamically managed subcomponents."

	(self _loggingStream respondsTo: aMessage selector)
		ifTrue: [ self _loggingStream perform: aMessage selector withArguments: aMessage arguments ]
		ifFalse: [ self _loggingStream 
			nextPutAll: 'WRAPPER ERROR: cannot forward message <';
			print: aMessage;
			nextPutAll: '>'.
			 ].
	
	^ wrappedStream perform: aMessage selector withArguments: aMessage arguments
]

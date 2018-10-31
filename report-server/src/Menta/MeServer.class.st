"
MeServer new start.
Teapot stopAll.
"
Class {
	#name : #MeServer,
	#superclass : #Object,
	#instVars : [
		'teapot',
		'logger'
	],
	#classInstVars : [
		'default'
	],
	#category : #Menta
}

{ #category : #examples }
MeServer class >> default [
	^ default ifNil: [ default := self new ]
]

{ #category : #examples }
MeServer class >> start [
	<example>
	
	^self default start
]

{ #category : #operations }
MeServer >> handleAfterRequest: aTeaRequest response: aResponse [
	logger
		logInfo:
			(String
				streamContents: [ :stream | 
					aResponse statusLine printCodeAndReasonOn: stream.
					aResponse hasEntity
						ifTrue: [ 
							stream space.
							aResponse entity printContentTypeAndLengthOn: stream ] ]).
	aResponse hasEntity
		ifTrue: [ logger logTrace: aResponse entity contents ]
]

{ #category : #handling }
MeServer >> handleAlive: aTeapotRequest [
	^ DateAndTime now asString
]

{ #category : #operations }
MeServer >> handleBeforeRequest: aTeaRequest [
	logger logInfo: (String streamContents: [ :stream | aTeaRequest requestLine printMethodAndUriOn: stream ])
]

{ #category : #operations }
MeServer >> initializeTeapot [
	logger := MeLogger new.
	teapot := Teapot configure: { #port -> self port }.
	teapot
		before: '*'              -> (Send message: #handleBeforeRequest: to: self);
		after:  '*'              -> (Send message: #handleAfterRequest:response: to: self);
		GET:    '/alive'         -> (Send message: #handleAlive: to: self);
		exception: MeError -> [ :ex :req | 
			logger logError: ex.
			TeaResponse badRequest body: { 'error' -> ex messageText } asDictionary ].

]

{ #category : #testing }
MeServer >> isRunning [
	^ teapot isNotNil and: [ teapot server isRunning ]
]

{ #category : #accessing }
MeServer >> port [
	^ 8083
]

{ #category : #printing }
MeServer >> printOn: aStream [
	super printOn: aStream.
	aStream
		space;
		nextPut: $(;
		print: self port;
		nextPutAll: ' - ';
		nextPutAll:
			(self isRunning
				ifTrue: [ 'running' ]
				ifFalse: [ 'stopped' ]);
		nextPut: $)
]

{ #category : #operations }
MeServer >> restart [
	self
		stop;
		start
]

{ #category : #operations }
MeServer >> start [
	self initializeTeapot.
	teapot start
]

{ #category : #operations }
MeServer >> stop [
	teapot stop
]

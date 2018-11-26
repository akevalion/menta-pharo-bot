"
This is a HTTP server that can receive Github hooks, which is the entry point of a ""Github App"".

See: https://developer.github.com/apps/


"
Class {
	#name : #MeServer,
	#superclass : #Object,
	#instVars : [
		'teapot',
		'logger',
		'handler'
	],
	#classInstVars : [
		'default'
	],
	#category : #'Menta-Server'
}

{ #category : #operations }
MeServer >> handleAfterRequest: aTeaRequest response: aResponse [
	logger logInfo: (String streamContents: [ :stream | aResponse statusLine printCodeAndReasonOn: stream ])
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
MeServer >> handleGithubHook: aTeaRequest [
	| eventString payloadDictionary actionString |

	"Check request and extract basic information"
	self verifyGithubHookSignatureOf: aTeaRequest.
	[ eventString := aTeaRequest headers at: 'X-Github-Event'.
	payloadDictionary := STON fromString: aTeaRequest entity string.
	actionString := payloadDictionary at: 'action' ]
		on: Error
		do: [ :anError | MeBadRequestError signal: anError messageText ].

	[ self handler handleEvent: eventString action: actionString payload: payloadDictionary ]
		on: Error
		do: [ :anError | 
			"Very useful for development"
			Smalltalk isHeadless
				ifTrue: [ anError signal ]
				ifFalse: [ anError debug ] ].

	"Nothing particular to respond the Github Webhook"
	^ ''
]

{ #category : #accessing }
MeServer >> handler [
	^ handler
]

{ #category : #accessing }
MeServer >> handler: anObject [
	handler := anObject
]

{ #category : #operations }
MeServer >> initializeTeapot [
	logger := MeLogger new.
	teapot := Teapot configure: { #port -> self port }.

	teapot
		before: '*'          -> (Send message: #handleBeforeRequest: to: self);
		after:  '*'          -> (Send message: #handleAfterRequest:response: to: self);

		GET:    '/alive'     -> (Send message: #handleAlive: to: self);
		POST:   '/'          -> (Send message: #handleGithubHook: to: self);

		exception: MeBadRequestError -> [ :ex :req | 
			logger logError: ex.
			TeaResponse badRequest body: { 'error' -> ex messageText } asDictionary ].

]

{ #category : #testing }
MeServer >> isRunning [
	^ teapot isNotNil and: [ teapot server isRunning ]
]

{ #category : #accessing }
MeServer >> logger [
	^ logger
]

{ #category : #accessing }
MeServer >> port [
	^ 3000
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
MeServer >> start [
	self initializeTeapot.
	teapot start
]

{ #category : #operations }
MeServer >> stop [
	teapot stop
]

{ #category : #operations }
MeServer >> verifyGithubHookSignatureOf: aTeaRequest [
	| hash secret signatureThatsExpected signatureInRequest |
	secret := (OSPlatform current environment asDictionary
		at: 'WEBHOOK_SECRET') asByteArray.
	signatureInRequest := aTeaRequest headers
		at: 'X-Hub-Signature'
		ifAbsent: [ '' ].
	hash := (HMAC on: SHA1)
		key: secret;
		digestMessage: aTeaRequest contents.
	signatureThatsExpected := 'sha1=' , hash hex.
	signatureThatsExpected = signatureInRequest
		ifFalse: [ MeBadRequestError signal: 'Wrong X-Hub-Signature' ].

]

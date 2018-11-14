"
Teapot stopAll.
MeServer new start.

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
	self verifySignatureOf: aTeaRequest.
	logger
		logInfo:
			(String
				streamContents: [ :stream | aTeaRequest requestLine printMethodAndUriOn: stream ])
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
MeServer >> verifySignatureOf: aTeaRequest [
	| hash secret calculatedSignature signature payload |
	
	"Todo: extract"
	Dotenv new dotenvFile: '../../probot-server/.env' asFileReference; config.
	
	
	secret := (OSPlatform current environment asDictionary
		at: 'WEBHOOK_SECRET') asByteArray.
	signature := aTeaRequest headers
		at: 'X-Hub-Signature'
		ifAbsent: [ '' ].
	hash := (HMAC on: SHA1)
		key: secret;
		digestMessage: aTeaRequest contents.
	calculatedSignature := 'sha1=' , hash hex.
	calculatedSignature = signature
		ifFalse: [ self error: 'wrong signature'	"TODO: What's the right answer?" ].
			
		

	(aTeaRequest headers at: 'X-Github-Event') logCr.
	"'issues'"	


	payload := STON fromString: aTeaRequest entity string.

1halt.

	IceGitHubAPI new 
		credentials: MeGithubAppCredentials new;
		addComment: (payload chainedAt: #(repository owner login))
			project: (payload chainedAt: #(repository name))
			number: (payload chainedAt: #(issue number))
			data: { #body -> 'messageString' } asDictionary.

]

"
My subclasses are Github Apps that operate with the Github API.

"
Class {
	#name : #MeGithubApp,
	#superclass : #Object,
	#instVars : [
		'id',
		'theName',
		'webhookSecret',
		'privateKeyPathAsString',
		'portNumber'
	],
	#category : #'Menta-Github App'
}

{ #category : #operations }
MeGithubApp >> handleAfterRequest: aTeaRequest response: aResponse [
	MeLogger current logInfo: (String streamContents: [ :stream | aResponse statusLine printCodeAndReasonOn: stream ])
]

{ #category : #handling }
MeGithubApp >> handleAlive: aTeapotRequest [
	^ DateAndTime now asString
]

{ #category : #operations }
MeGithubApp >> handleBeforeRequest: aTeaRequest [
	MeLogger current logInfo: (String streamContents: [ :stream | aTeaRequest requestLine printMethodAndUriOn: stream ])
]

{ #category : #operations }
MeGithubApp >> handleGithubHook: aTeaRequest [
	| webhook |
	webhook := MeGithubWebhook newFrom: aTeaRequest.

	"For security reasons, verify the request."
	webhook verifySignatureWithSecret: (OSPlatform current environment asDictionary at: 'WEBHOOK_SECRET') asByteArray.
		
	"Handle"
	[ self handleWebhook: webhook ]
		on: Error
		do: [ :anError | 
			"Very useful for development"
			Smalltalk isHeadless
				ifTrue: [ anError signal ]
				ifFalse: [ anError debug ] ].

	"Nothing particular to respond the Github Webhook"
	^ ''
]

{ #category : #operations }
MeGithubApp >> handleWebhook: aMeGithubWebhook [

	^ self subclassResponsibility
]

{ #category : #accessing }
MeGithubApp >> id [
	^ id
]

{ #category : #accessing }
MeGithubApp >> id: anObject [
	id := anObject
]

{ #category : #accessing }
MeGithubApp >> portNumber [
	^ portNumber
]

{ #category : #accessing }
MeGithubApp >> portNumber: anObject [
	portNumber := anObject
]

{ #category : #accessing }
MeGithubApp >> privateKeyPathAsString [
	^ privateKeyPathAsString
]

{ #category : #accessing }
MeGithubApp >> privateKeyPathAsString: aString [
	privateKeyPathAsString := aString
]

{ #category : #operations }
MeGithubApp >> start [
	| teapot |
	teapot := Teapot configure: { #port -> portNumber }.

	teapot
		before: '*'          -> (Send message: #handleBeforeRequest: to: self);
		after:  '*'          -> (Send message: #handleAfterRequest:response: to: self);

		GET:    '/alive'     -> (Send message: #handleAlive: to: self);
		POST:   '/'          -> (Send message: #handleGithubHook: to: self);

		exception: MeBadRequestError -> [ :ex :req | 
			MeLogger current logError: ex.
			TeaResponse badRequest body: { 'error' -> ex messageText } asDictionary ].

	^ teapot start
]

{ #category : #accessing }
MeGithubApp >> theName [
	^ theName
]

{ #category : #accessing }
MeGithubApp >> theName: anObject [
	theName := anObject
]

{ #category : #accessing }
MeGithubApp >> webhookSecret [
	^ webhookSecret
]

{ #category : #accessing }
MeGithubApp >> webhookSecret: anObject [
	webhookSecret := anObject
]

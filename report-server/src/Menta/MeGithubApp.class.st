"
My subclasses are Github Apps that operate with the Github API.

For new subclasses
==================

Create a Github App in the web browser, then use the generated data to create an instance with:

| app |
app := MyNewApp new
	id: 12345;
	theName: 'my-new-app';
	...
	yourself.

You can find the required data at:

https://github.com/settings/apps/<the-github-app-name>


Now, you may write the instance to disk with:	
	
MeEasy write: app toStonFileAt: 'MyNewApp.ston' asFileReference.


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

{ #category : #accessing }
MeGithubApp >> freshAccessTokenFor: installationId [
	"Answer a (not expired) access token for the specified installation id.
	
	Note: These tokens are valid for 60 minutes.
	"
	
	| payload |
	payload := MeGithubAPI new
		credentials: self freshGithubAppCredentials;
		setRelativeUrlForInstallationAccessToken: installationId;
		post.

	self flag: #todo. "cache!"
	^ (STON fromString: payload) at: 'token'

]

{ #category : #accessing }
MeGithubApp >> freshGithubAppCredentials [
	"Answer a new instance with a new JWT.
	
	Note: JWT are valid for 10 minutes. 
	Source: https://developer.github.com/apps/building-github-apps/authenticating-with-github-apps/#authenticating-as-a-github-app
	"
	self flag: #todo. "cache!"

	^ MeGithubAppCredentials new
		jwtString: self freshJWT;
		githubAppName: theName;
		yourself
	
]

{ #category : #accessing }
MeGithubApp >> freshJWT [
	self flag: #todo. "cache!"

	OSSUnixSubprocess new
		shellCommand: ('node ../../jwt-token-generator/index.js {1} {2}' format: { id. privateKeyPathAsString });
		redirectStdout;
		runAndWaitOnExitDo: [ :command :outString | 
			"Last character is lf, which breaks the HTTP request header." 
			^ outString allButLast ]
]

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

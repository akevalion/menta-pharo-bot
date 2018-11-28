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

{ #category : #server }
MeGithubApp >> convertedToJson: object [
	^ String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				writeNil: true;
"				for: VOTestDog do: [ :mapping |
					mapping mapInstVars: #(name) ];
				mapAllInstVarsFor: VOTestOwner;"
				nextPut: object ]
]

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

{ #category : #operations }
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
	webhook verifySignatureWithSecret: webhookSecret.
		
	"Handle by subclass"
	self handleWebhook: webhook.

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

{ #category : #server }
MeGithubApp >> newTeapot [
	| teapot |
	teapot := Teapot configure: { 
		#port -> portNumber.
		#defaultOutput -> [ :resp :req | 
			| entity |
			entity := ZnStringEntity 
				with: (self convertedToJson: resp body)
				type: (ZnMimeType applicationJson charSet: resp charSet; yourself).
			TeaOutput 
				znEntity: entity
				code: resp code 
				headers: resp headers ].
	}.


	teapot
		before: '*'          -> (Send message: #handleBeforeRequest: to: self);
		after:  '*'          -> (Send message: #handleAfterRequest:response: to: self);

		GET:    '/alive'     -> (Send message: #handleAlive: to: self);
		POST:   '/'          -> (Send message: #handleGithubHook: to: self);

		exception: MeBadRequestError -> [ :error :request | 
			MeLogger current logError: error.
			TeaResponse badRequest
				body: { 'error' -> error messageText } asDictionary;
				yourself ];
		
		exception: Error -> [ :error :request |
			MeLogger current logError: error.
			"Very useful for development"
			Smalltalk isHeadless ifFalse: [ error debug ].
			TeaResponse serverError
				body: { 'error' -> error messageText } asDictionary;
				yourself ].

	^ teapot start
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

{ #category : #server }
MeGithubApp >> start [
	^ self newTeapot start
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

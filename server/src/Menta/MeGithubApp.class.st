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
		'portNumber',
		'appCredentials',
		'installationCredentialsCache'
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
MeGithubApp >> freshGithubAppCredentials [
	appCredentials ifNil: [ 
		appCredentials := MeGithubAppCredentials new
			githubApp: self;
			yourself ].
	^ appCredentials
		ensureFresh;
		yourself
]

{ #category : #handling }
MeGithubApp >> freshInstallationCredentialsFor: installationId [
	| installationCredentials |
	installationCredentials := self installationCredentialsCache
		at: installationId
		ifAbsentPut: [
			MeGithubAppInstallationCredentials new
				githubApp: self;
				installationId: installationId;
				yourself ].
	^ installationCredentials
		ensureFresh;
		yourself
]

{ #category : #operations }
MeGithubApp >> handleAfterRequest: aTeaRequest response: aResponse [
	MeLogger current logInfo: (String streamContents: [ :stream | aResponse statusLine printCodeAndReasonOn: stream ])
]

{ #category : #operations }
MeGithubApp >> handleAlive: aTeapotRequest [
	^ { 'now' -> DateAndTime now asString } asDictionary
]

{ #category : #operations }
MeGithubApp >> handleBeforeRequest: aTeaRequest [
	MeLogger current logInfo: (String streamContents: [ :stream | aTeaRequest requestLine printMethodAndUriOn: stream ])
]

{ #category : #operations }
MeGithubApp >> handleGithubRequest: aTeaRequest [
	| webhook |
	webhook := MeGithubWebhook newFrom: aTeaRequest.

	"For security reasons, verify the request."
	webhook verifySignatureWithSecret: webhookSecret.
		
	"Handle by subclass"
	self handleWebhook: webhook.

	"Nothing particular to respond to Github"
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

{ #category : #handling }
MeGithubApp >> installationCredentialsCache [
	^ installationCredentialsCache ifNil: [ installationCredentialsCache := Dictionary new ]
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
		POST:   '/'          -> (Send message: #handleGithubRequest: to: self);

		exception: MeBadRequestError -> [ :error :request | 
			MeLogger current logError: error.
			TeaResponse badRequest
				body: { 'error' -> error messageText } asDictionary;
				yourself ];
		
		exception: Error -> [ :error :request |
			MeLogger current logError: error.
			"Very useful for development"
			MeEasy isMorphicUIManagerActive ifTrue: [ error debug ].
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

"
Eases interaction with a TeaRequest that arrived from the Github Webhooks system.

See: https://developer.github.com/webhooks/
"
Class {
	#name : #MeGithubWebhook,
	#superclass : #Object,
	#instVars : [
		'teaRequest',
		'payload'
	],
	#category : #'Menta-Github App'
}

{ #category : #'instance creation' }
MeGithubWebhook class >> newFrom: aTeaRequest [
	^ self basicNew
		initializeFrom: aTeaRequest;
		yourself
]

{ #category : #accessing }
MeGithubWebhook >> action [
	^ self payload at: 'action'
]

{ #category : #accessing }
MeGithubWebhook >> event [
	^ teaRequest headers at: 'X-Github-Event'
]

{ #category : #API }
MeGithubWebhook >> initializeFrom: aTeaRequest [
	self initialize.
	teaRequest := aTeaRequest
]

{ #category : #'as yet unclassified' }
MeGithubWebhook >> payload [
	^ payload ifNil: [ payload := STON fromString: teaRequest entity string ]
]

{ #category : #accessing }
MeGithubWebhook >> teaRequest [
	^ teaRequest
]

{ #category : #API }
MeGithubWebhook >> verifySignatureWithSecret: aWebhookSecret [
	"Once the server is configured to receive payloads, it'll listen for any payload sent to the endpoint. For security reasons, you probably want to limit requests to those coming from GitHub. There are a few ways to go about this--for example, you could opt to whitelist requests from GitHub's IP address--but a far easier method is to set up a secret token and validate the information.

	Source: https://developer.github.com/webhooks/securing/
	"

	| hash signatureThatsExpected signatureInRequest |
	signatureInRequest := teaRequest headers 
		at: 'X-Hub-Signature'
		ifAbsent: [ MeBadRequestError signal: 'Missing X-Hub-Signature' ].

	hash := (HMAC on: SHA1)
		key: aWebhookSecret;
		digestMessage: teaRequest contents.
	signatureThatsExpected := 'sha1=' , hash hex.
	
	self flag: #todo.
		"Using constant time string comparison is not advised.
		See https://developer.github.com/webhooks/securing/."
	signatureThatsExpected = signatureInRequest
		ifFalse: [ MeBadRequestError signal: 'Wrong X-Hub-Signature' ]
]

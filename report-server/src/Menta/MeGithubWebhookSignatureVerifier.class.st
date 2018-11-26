"
Once the server is configured to receive payloads, it'll listen for any payload sent to the endpoint. For security reasons, you probably want to limit requests to those coming from GitHub. There are a few ways to go about this--for example, you could opt to whitelist requests from GitHub's IP address--but a far easier method is to set up a secret token and validate the information.

Source: https://developer.github.com/webhooks/securing/
"
Class {
	#name : #MeGithubWebhookSignatureVerifier,
	#superclass : #Object,
	#instVars : [
		'webhookSecret'
	],
	#category : #'Menta-Server'
}

{ #category : #API }
MeGithubWebhookSignatureVerifier >> verify: aTeaRequest [
	| hash signatureThatsExpected signatureInRequest |
	signatureInRequest := aTeaRequest headers 
		at: 'X-Hub-Signature'
		ifAbsent: [ MeBadRequestError signal: 'Missing X-Hub-Signature' ].

	hash := (HMAC on: SHA1)
		key: self webhookSecret;
		digestMessage: aTeaRequest contents.
	signatureThatsExpected := 'sha1=' , hash hex.
	
	self flag: #todo.
		"Using constant time string comparison is not advised.
		See https://developer.github.com/webhooks/securing/."
	signatureThatsExpected = signatureInRequest
		ifFalse: [ MeBadRequestError signal: 'Wrong X-Hub-Signature' ]
]

{ #category : #accessing }
MeGithubWebhookSignatureVerifier >> webhookSecret [
	^ webhookSecret
]

{ #category : #accessing }
MeGithubWebhookSignatureVerifier >> webhookSecret: anObject [
	webhookSecret := anObject
]

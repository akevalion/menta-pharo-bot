"
Authenticating as a GitHub App lets you do a couple of things:

    You can retrieve high-level management information about your GitHub App.
    You can request access tokens for an installation of the app.

To authenticate as a GitHub App, generate a private key in PEM format and download it to your local machine. You'll use this key to sign a JSON Web Token (JWT) and encode it using the RS256 algorithm. GitHub checks that the request is authenticated by verifying the token with the app's stored public key.

Source: https://developer.github.com/apps/building-github-apps/authenticating-with-github-apps/#jwt-payload
"
Class {
	#name : #MeGithubAppCredentials,
	#superclass : #MeGithubAppAbstractCredentials,
	#instVars : [
		'jwtString'
	],
	#category : #'Menta-Github API'
}

{ #category : #'as yet unclassified' }
MeGithubAppCredentials class >> freshJWT [
	OSSUnixSubprocess new
		shellCommand: 'node ../../jwt-token-generator/index.js';
		redirectStdout;
		runAndWaitOnExitDo: [ :command :outString | 
			"Last character is lf, which breaks the HTTP request header." 
			^ outString allButLast ]
]

{ #category : #'as yet unclassified' }
MeGithubAppCredentials class >> withFreshJWTGithubAppName: aString [
	"Answer a new instance with a new JWT.
	
	Note: JWT are valid for 10 minutes. 
	Source: https://developer.github.com/apps/building-github-apps/authenticating-with-github-apps/#authenticating-as-a-github-app
	"

	^ self new
		jwtString: self freshJWT;
		githubAppName: aString;
		yourself
]

{ #category : #options }
MeGithubAppCredentials >> applyTo: aZnClient [
	"Prepare the headers of the HTTP client with the Github App authentication.
	
	Links:
	https://developer.github.com/apps/building-github-apps/authenticating-with-github-apps/#jwt-payload"

	super applyTo: aZnClient.
	aZnClient headerAt: 'Authorization' put: 'Bearer ' , self jwtString
]

{ #category : #options }
MeGithubAppCredentials >> jwtString [
	^ jwtString
]

{ #category : #options }
MeGithubAppCredentials >> jwtString: aString [
	jwtString := aString
]

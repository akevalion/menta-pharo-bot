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
		'jwtString',
		'jwtExpireTime'
	],
	#category : #'Menta-Github API'
}

{ #category : #operations }
MeGithubAppCredentials >> applyTo: aZnClient [
	"Prepare a HTTP request (in the ZnClient) to authenticate as a Github App.
	
	Source:
	https://developer.github.com/apps/building-github-apps/authenticating-with-github-apps/#jwt-payload
	"

	super applyTo: aZnClient.
	aZnClient headerAt: 'Authorization' put: 'Bearer ' , self jwtString
]

{ #category : #options }
MeGithubAppCredentials >> ensureFresh [
	self shouldRefreshJwt
		ifTrue: [ self refreshJwt ]
]

{ #category : #options }
MeGithubAppCredentials >> jwtDuration [
	"By definition, JWT are valid for 10 minutes. Source: https://developer.github.com/apps/building-github-apps/authenticating-with-github-apps/#authenticating-as-a-github-app"

	^ 10 minutes
]

{ #category : #options }
MeGithubAppCredentials >> jwtString [
	^ jwtString
]

{ #category : #options }
MeGithubAppCredentials >> newJwtString [
	OSSUnixSubprocess new
		shellCommand: ('node {1}/jwt-generator/index.js {2} {3}' 
			format: {
				Menta repositoryPath pathString.
				githubApp id. 
				githubApp privateKeyPathAsString });
		redirectStdout;
		runAndWaitOnExitDo: [ :command :outString | 
			"Last character is lf, which breaks the HTTP request header." 
			^ outString allButLast ]
]

{ #category : #options }
MeGithubAppCredentials >> refreshJwt [
	jwtExpireTime := DateAndTime now + self jwtDuration.
	jwtString := self newJwtString
]

{ #category : #options }
MeGithubAppCredentials >> shouldRefreshJwt [
	"Tells if the jwtString is valid."

	^ jwtString isNil or: [ DateAndTime now > jwtExpireTime ]
]

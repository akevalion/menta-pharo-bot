Class {
	#name : #MeGithubAppCredentials,
	#superclass : #IceSshCredentials,
	#category : #Menta
}

{ #category : #tests }
MeGithubAppCredentials class >> test [
	<example>
	| client |
	client := ZnClient new
		url: 'https://api.github.com/app';
		headerAt: 'Accept' put: 'application/vnd.github.machine-man-preview+json';
		yourself.
	self new prepareRequest: client.
	client get inspect
]

{ #category : #options }
MeGithubAppCredentials >> jwtString [
	OSSUnixSubprocess new
		shellCommand: 'node ../../jwt-token-generator/index.js';
		redirectStdout;
		runAndWaitOnExitDo: [ :command :outString |
			"Last character is lf, which breaks the HTTP request header."
			^ outString allButLast ]
]

{ #category : #options }
MeGithubAppCredentials >> prepareRequest: aZnClient [
	"Prepare the headers of the HTTP client with the Github App authentication.
	
	Links:
	https://developer.github.com/apps/building-github-apps/authenticating-with-github-apps/#jwt-payload
	https://developer.github.com/v3/#user-agent-required"
	
	aZnClient
		headerAt: 'Authorization' put: 'Bearer ' , self jwtString;
"		headerAt: 'Accept' put: 'application/vnd.github.machine-man-preview+json';"
		headerAt: 'User-Agent' put: 'menta-pharo-bot'
]

{ #category : #options }
MeGithubAppCredentials >> test [

ZnClient new
	url: 'https://api.github.com/app';
	headerAt: 'Accept' 
		put: 'application/vnd.github.machine-man-preview+json';
	get.	

]

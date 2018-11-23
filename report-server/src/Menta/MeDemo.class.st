"
How to Prepare
==============

1. Run in a terminal, in the root of the repository:

sshfs -o nonempty -p722 mdias@gate.dcc.uchile.cl:public/ ./public


2. Evaluate in this image:
 
Dotenv new path: '../../.env' asFileReference; config.
Teapot stopAll.
MeDemo new 
	publicFiles: (MePublicFiles new
		url: 'http://gate.dcc.uchile.cl:3000/public/';
		path: (FileLocator imageDirectory parent parent / 'public') asPath;
		yourself);
	start.


3. Probe alive with:

curl localhost:3000/alive


4. In dev environment, start smee client:

cd ../../smee-client-util/ && node start-smee.js


5. Trigger Github Hooks

"
Class {
	#name : #MeDemo,
	#superclass : #MeServer,
	#instVars : [
		'publicFiles'
	],
	#category : #Menta
}

{ #category : #operations }
MeDemo >> accessTokenFor: installationId [
	| client payload |
	client := ZnClient new
		url: ('https://api.github.com/app/installations/{1}/access_tokens' format: {installationId});
		headerAt: 'Accept' put: 'application/vnd.github.machine-man-preview+json';
		yourself.
	MeGithubAppCredentials new prepareRequest: client.
	

	payload := STON fromString: client post.
	^ payload at: 'token'

]

{ #category : #handling }
MeDemo >> createComment: aString payload: payloadDictionary [

	| accessToken |
	accessToken := self accessTokenFor: (payloadDictionary chainedAt: #(installation id)).
	IceGitHubAPI new 
		credentials: (MeGithubAppInstallationCredentials new accessToken: accessToken; yourself);
		addComment: (payloadDictionary chainedAt: #(repository owner login))
			project: (payloadDictionary chainedAt: #(repository name))
			number: (payloadDictionary chainedAt: #(issue number))
			data: { #body -> aString } asDictionary.



]

{ #category : #handling }
MeDemo >> exportCloudFor: aString at: pngPath [
	| canvas |
	canvas := (RTNameCloud new
		addString: (' ' join: aString);
		build) view canvas.

	(RTCanvasExporter canvas: canvas)
		withoutFixedShapes;
		whole;
		defaultScale;
		oversizedBy: 5 @ 5;
		format: #png;
		fileName: pngPath asFileReference;
		export
]

{ #category : #operations }
MeDemo >> handleGithubEvent: eventString payload: payloadDictionary [

	(eventString = 'issues' and: [ 'edited' = (payloadDictionary at: 'action') ])
		ifTrue: [ self handleIssuesEdited: payloadDictionary ]
		ifFalse: [ 1halt ]
]

{ #category : #handling }
MeDemo >> handleIssuesEdited: payloadDictionary [
	| oldText newText base fileNameForOld fileNameForNew comment |
	oldText := payloadDictionary chainedAt: #(changes body from).
	newText := payloadDictionary chainedAt: #(issue body).
	
	base := UUID new asString36.
	fileNameForOld := base, '-old.png'.
	self exportCloudFor: oldText at: (publicFiles pathFor: fileNameForOld).

	fileNameForNew := base, '-new.png'.
	self exportCloudFor: newText at: (publicFiles pathFor: fileNameForNew).
	
	comment := 'You edited a comment:

| Before | After |
| ------ | ----- |
| ![Before]({1}) | ![After]({2}) |
' format: {publicFiles urlFor: fileNameForOld. publicFiles urlFor: fileNameForNew}.

	self createComment: comment payload: payloadDictionary.
]

{ #category : #accessing }
MeDemo >> publicFiles [
	^ publicFiles
]

{ #category : #accessing }
MeDemo >> publicFiles: anObject [
	publicFiles := anObject
]

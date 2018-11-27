"
This is a demo Github App.

First time
==========

Create a Github App, then create an instance with:

| app |
app := MeDemoApp new
	publicFiles: (MePublicFiles new
		url: 'http://gate.dcc.uchile.cl:3000/public/';
		path: (FileLocator imageDirectory parent parent / 'public') asPath;
		yourself);
	...
	yourself);
MeEasy write: app toStonFileAt: 'MyApp.ston' asFileReference.

You can find the required data at:

https://github.com/settings/apps/<the-github-app-name>


How to start in dev environment
===============================

1. Start a HTTP server with the app described in the file with:

Teapot stopAll. (MeEasy readFromStonFileAt: '../../MeDemoApp.ston' asFileReference) start.


2. Probe liveness with:

curl localhost:3000/alive


3. Run in a terminal (from build/ directory):

sshfs -o nonempty -p722 mdias@gate.dcc.uchile.cl:public/ ~/public
node ../../smee-client-util/start-smee.js


"
Class {
	#name : #MeDemoApp,
	#superclass : #MeGithubApp,
	#instVars : [
		'publicFiles'
	],
	#category : #'Menta-Github App'
}

{ #category : #operations }
MeDemoApp >> accessTokenFor: installationId [
	| payload |
	payload := MeGithubAPI new
		credentials: (MeGithubAppCredentials withFreshJWTGithubAppName: theName);
		setRelativeUrlForInstallationAccessToken: installationId;
		post.

	^ (STON fromString: payload) at: 'token'

]

{ #category : #handling }
MeDemoApp >> createComment: aString payload: payloadDictionary [

	| accessToken |
	accessToken := self accessTokenFor: (payloadDictionary chainedAt: #(installation id)).

	MeGithubAPI new 
		credentials: (MeGithubAppInstallationCredentials new 
			accessToken: accessToken; 
			githubAppName: theName;
			yourself);
		setRelativeUrlForCommentsOnOwner: (payloadDictionary chainedAt: #(repository owner login))
			project: (payloadDictionary chainedAt: #(repository name))
			number: (payloadDictionary chainedAt: #(issue number));
		json: { #body -> aString } asDictionary;
		post.

]

{ #category : #handling }
MeDemoApp >> exportCloudFor: aString at: pngPath [
	| view canvas |
	view := (RTNameCloud new addString: (' ' join: aString); build) view.
	canvas := view canvas.

	(RTCanvasExporter canvas: canvas)
		withoutFixedShapes;
		whole;
		defaultScale;
		oversizedBy: 5 @ 5;
		format: #png;
		fileName: pngPath asFileReference;
		export
]

{ #category : #handling }
MeDemoApp >> handleIssuesEdited: payloadDictionary [
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

{ #category : #operations }
MeDemoApp >> handleWebhook: aMeGithubWebhook [

	(aMeGithubWebhook event = 'issues' and: [ aMeGithubWebhook action = 'edited' ])
		ifTrue: [ self handleIssuesEdited: aMeGithubWebhook payload ]
		ifFalse: [ Halt if: [ Smalltalk isHeadless not ] ]
]

{ #category : #accessing }
MeDemoApp >> publicFiles [
	^ publicFiles
]

{ #category : #accessing }
MeDemoApp >> publicFiles: anObject [
	publicFiles := anObject
]

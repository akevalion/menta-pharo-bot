"
This is a demo Github App.

First time
==========

You should create your own Github App in the web and then fill this configuration file:

Menta repositoryPath / 'MeDemoApp.ston'


For that, you can find the required data at:

https://github.com/settings/apps/<the-github-app-name>


How to start in dev environment
===============================

1. Start a HTTP server with the app described in the file with:

Teapot stopAll. (MeEasy readFromStonFileAt: Menta repositoryPath / 'MeDemoApp.ston') start.


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

{ #category : #examples }
MeDemoApp class >> exampleFromFile [
	<example>
	
	"
	Teapot stopAll. 
	"
	^ (MeEasy readFromStonFileAt: self fileReferenceToExampleConfigurationFile) start; inspect.
	
]

{ #category : #examples }
MeDemoApp class >> fileReferenceToExampleConfigurationFile [

	^ (Menta repositoryPath / self instanceSide name, 'ston') asFileReference
]

{ #category : #handling }
MeDemoApp >> createComment: aString payload: payloadDictionary [

	| accessToken |
	accessToken := self freshAccessTokenFor: (payloadDictionary chainedAt: #(installation id)).

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

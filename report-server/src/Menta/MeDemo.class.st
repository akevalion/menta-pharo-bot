"
How to Prepare
==============

1. Run in a terminal, in the root of the repository:

sshfs -o nonempty -p722 mdias@gate.dcc.uchile.cl:public/ ./public


2. Evaluate in this image:
 
Dotenv new path: '../../probot-server/.env' asFileReference; config.
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

cd probot-server/ && node start-smee.js


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

	1halt.

	IceGitHubAPI new 
		credentials: MeGithubAppCredentials new;
		addComment: (payloadDictionary chainedAt: #(repository owner login))
			project: (payloadDictionary chainedAt: #(repository name))
			number: (payloadDictionary chainedAt: #(issue number))
			data: { #body -> 'messageStringggg' } asDictionary.

]

{ #category : #handling }
MeDemo >> handleIssuesEdited: req [
	| payload oldText newText base fileNameForOld fileNameForNew |
	payload := STON fromString: req entity string.
	oldText := payload chainedAt: #(changes body from).
	newText := payload chainedAt: #(issue body).
	
	base := UUID new asString36.
	fileNameForOld := base, '-old.png'.
	self exportCloudFor: oldText at: (publicFiles pathFor: fileNameForOld).

	fileNameForNew := base, '-new.png'.
	self exportCloudFor: newText at: (publicFiles pathFor: fileNameForNew).
	
	^'You edited a comment:

| Before | After |
| ------ | ----- |
| ![Before]({1}) | ![After]({2}) |
' format: {publicFiles urlFor: fileNameForOld. publicFiles urlFor: fileNameForNew}

]

{ #category : #accessing }
MeDemo >> publicFiles [
	^ publicFiles
]

{ #category : #accessing }
MeDemo >> publicFiles: anObject [
	publicFiles := anObject
]

"
This is a demo Github App.

Setup
=====

You should create your own Github App in the web and then fill this configuration file:

Menta repositoryPath / 'MeDemoApp.ston'


For that, you can find the required data at:

https://github.com/settings/apps/<the-github-app-name>


Start HTTP server
=================

Teapot stopAll. (MeEasy readFromStonFileAt: Menta repositoryPath / 'MeDemoApp.ston') start.

"
Class {
	#name : #MeDemoApp,
	#superclass : #MeGithubApp,
	#instVars : [
		'filePublisher'
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
	MeGithubAPI new
		credentials: (self freshInstallationCredentialsFor: (payloadDictionary chainedAt: #(installation id)));
		setRelativeUrlForCommentsOnOwner: (payloadDictionary chainedAt: #(repository owner login))
			project: (payloadDictionary chainedAt: #(repository name))
			number: (payloadDictionary chainedAt: #(issue number));
		json: { #body -> aString } asDictionary;
		post
]

{ #category : #handling }
MeDemoApp >> exportCloudFor: aString at: aFileReference [
	| view canvas |
	view := (RTNameCloud new addString: (' ' join: aString); build) view.
	canvas := view canvas.

	(RTCanvasExporter canvas: canvas)
		withoutFixedShapes;
		whole;
		defaultScale;
		oversizedBy: 5 @ 5;
		format: #png;
		fileName: aFileReference;
		export
]

{ #category : #accessing }
MeDemoApp >> filePublisher [
	^ filePublisher
]

{ #category : #accessing }
MeDemoApp >> filePublisher: aMeFilePublisher [
	filePublisher := aMeFilePublisher
]

{ #category : #handling }
MeDemoApp >> handleIssuesEdited: payloadDictionary [
	| oldText newText base comment urlForOld urlForNew |
	oldText := payloadDictionary chainedAt: #(changes body from).
	newText := payloadDictionary chainedAt: #(issue body).
	
	base := UUID new asString36.
	urlForOld := filePublisher
		publishAtUniqueFileName: base, '-old.png'
		do: [:aFileReference | self exportCloudFor: oldText at: aFileReference ].
	urlForNew := filePublisher
		publishAtUniqueFileName: base, '-new.png'
		do: [:aFileReference | self exportCloudFor: newText at: aFileReference ].
	
	comment := 'You edited a comment:

| Before | After |
| ------ | ----- |
| ![Before]({1}) | ![After]({2}) |
' format: { urlForOld. urlForNew }.

	self createComment: comment payload: payloadDictionary.
]

{ #category : #operations }
MeDemoApp >> handleWebhook: aMeGithubWebhook [

	(aMeGithubWebhook event = 'issues' and: [ aMeGithubWebhook action = 'edited' ])
		ifTrue: [ self handleIssuesEdited: aMeGithubWebhook payload ]
		ifFalse: [ Halt if: [ Smalltalk isHeadless not ] ]
]

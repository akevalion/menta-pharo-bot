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

{ #category : #operations }
MeDemoApp >> createComment: aString payload: payloadDictionary [
	MeGithubAPI new
		credentials: (self freshInstallationCredentialsFor: (payloadDictionary chainedAt: #(installation id)));
		setRelativeUrlForCommentsOnOwner: (payloadDictionary chainedAt: #(repository owner login))
			project: (payloadDictionary chainedAt: #(repository name))
			number: (payloadDictionary chainedAt: #(issue number));
		json: { #body -> aString } asDictionary;
		post
]

{ #category : #operations }
MeDemoApp >> exportArrowDiffFrom: oldText to: newText at: aFileReference [
	
	| view e1 e2 |
	view := RTView new.

	e1 := RTLabel new elementOn: oldText.
	e2 := RTLabel new elementOn: newText.
	view add: e1; add: e2.

	view add: (RTEdge from: e1 to: e2) + (RTLine new color: Color red) + (RTSimpleArrowHead new color: Color red).

	RTTreeLayout on: {e1. e2}.

	(RTCanvasExporter canvas: view canvas)
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

{ #category : #operations }
MeDemoApp >> handleIssueCommentCreated: payloadDictionary [
	
	| text base comment url |
	'Bot' = (payloadDictionary chainedAt: #(sender type)) ifTrue: [
		"Avoid infinite cycle!"
		^ self ].
	
	text := payloadDictionary chainedAt: #(comment body).
	
	base := UUID new asString36.
	url := filePublisher
		publishAtUniqueFileName: base, '.png'
		do: [:aFileReference | self exportArrowDiffFrom: '' to: text at: aFileReference ].
	
	comment := 'You created a comment:
![Visual Diff]({1})
' format: { url }.

	self createComment: comment payload: payloadDictionary.
]

{ #category : #operations }
MeDemoApp >> handleIssueCommentEdited: payloadDictionary [
	| oldText newText base comment url |
	'Bot' = (payloadDictionary chainedAt: #(comment user type)) ifTrue: [
		"Arbitrary decision: ignore edits on a Bot comment."
		^ self ].

	oldText := payloadDictionary chainedAt: #(changes body from).
	newText := payloadDictionary chainedAt: #(comment body).
	
	base := UUID new asString36.
	url := filePublisher
		publishAtUniqueFileName: base, '.png'
		do: [:aFileReference | self exportArrowDiffFrom: oldText to: newText at: aFileReference ].
	
	comment := 'You edited a comment:
![Visual Diff]({1})
' format: { url }.

	self createComment: comment payload: payloadDictionary.
]

{ #category : #operations }
MeDemoApp >> handleWebhook: aMeGithubWebhook [

	| actionSpec |
	actionSpec := { aMeGithubWebhook event. aMeGithubWebhook action }.

	actionSpec = #('issue_comment' 'created') ifTrue: [ 
		^ self handleIssueCommentCreated: aMeGithubWebhook payload ].

	actionSpec = #('issue_comment' 'edited') ifTrue: [ 
		^ self handleIssueCommentEdited: aMeGithubWebhook payload ].

	MeEasy isMorphicUIManagerActive
		ifTrue: [ Halt now ]
		ifFalse: [ MeLogger current logInfo: 'Ignored: ', actionSpec asString ]
]

"
Teapot stopAll.
MeDemo new 
	publicFiles: (MePublicFiles new
		url: 'http://gate.dcc.uchile.cl:3000/public/';
		path: (FileLocator imageDirectory parent parent / 'public') asPath;
		yourself);
	start.

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

{ #category : #operations }
MeDemo >> initializeTeapot [
	super initializeTeapot.
	teapot
		POST:   '/issues.edited' -> (Send message: #handleIssuesEdited: to: self)

]

{ #category : #accessing }
MeDemo >> publicFiles [
	^ publicFiles
]

{ #category : #accessing }
MeDemo >> publicFiles: anObject [
	publicFiles := anObject
]

"
Teapot stopAll.
MeDemo new 
	basePublicUrl: 'http://localhost:3000/public/';
	basePublicPath: (FileLocator imageDirectory parent parent / 'public') asPath;
	start.

"
Class {
	#name : #MeDemo,
	#superclass : #MeServer,
	#instVars : [
		'basePublicUrl',
		'basePublicPath'
	],
	#category : #Menta
}

{ #category : #accessing }
MeDemo >> basePublicPath [
	^ basePublicPath
]

{ #category : #accessing }
MeDemo >> basePublicPath: anObject [
	basePublicPath := anObject
]

{ #category : #accessing }
MeDemo >> basePublicUrl [
	^ basePublicUrl
]

{ #category : #accessing }
MeDemo >> basePublicUrl: anObject [
	basePublicUrl := anObject
]

{ #category : #handling }
MeDemo >> exportLetterCloudFor: aString fileName: fileName [
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
		fileName: (self publicPathFor: fileName);
		export
]

{ #category : #handling }
MeDemo >> handleIssuesEdited: req [
	| payload oldText newText fileNameForOld fileNameForNew |
	payload := STON fromString: req entity string.
	oldText := payload chainedAt: #(changes body from).
	newText := payload chainedAt: #(issue body).
	
	fileNameForOld := UUID new asString36, '.png'.
	self exportLetterCloudFor: oldText fileName: fileNameForOld.

	fileNameForNew := UUID new asString36, '.png'.
	self exportLetterCloudFor: newText fileName: fileNameForNew.
	
	^'You edited a comment:

| Before | After |
| ------ | ----- |
| ![Before]({1}) | ![After]({2}) |
' format: {self publicUrlFor: fileNameForOld. self publicUrlFor: fileNameForNew}

]

{ #category : #operations }
MeDemo >> initializeTeapot [
	super initializeTeapot.
	teapot
		POST:   '/issues.edited' -> (Send message: #handleIssuesEdited: to: self)

]

{ #category : #handling }
MeDemo >> publicPathFor: fileName [
	^ (basePublicPath / fileName) canonicalize pathString
]

{ #category : #handling }
MeDemo >> publicUrlFor: fileName [
	^ '{1}{2}' format: {basePublicUrl. fileName}
]

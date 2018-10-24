"
MeServer new start.
Teapot stopAll.
"
Class {
	#name : #MeServer,
	#superclass : #Object,
	#instVars : [
		'teapot',
		'logger'
	],
	#classInstVars : [
		'default'
	],
	#category : #Menta
}

{ #category : #examples }
MeServer class >> default [
	^ default ifNil: [ default := self new ]
]

{ #category : #examples }
MeServer class >> start [
	<example>
	
	^self default start
]

{ #category : #operations }
MeServer >> convertedToJson: object [
	^ String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				writeNil: true;
				nextPut: object ]
]

{ #category : #handling }
MeServer >> handleIssuesEdited: req [
	| payload |
	payload := STON fromString: req entity string.
	payload inspect.
	^ 'Very nice, you edited "' , (((payload at: 'changes') at: 'body') at: 'from') , '". I may approve it.'
]

{ #category : #operations }
MeServer >> initializeTeapot [
	logger := MeLogger new.
	teapot := Teapot configure: {
		#port -> 8083.
		#debugMode -> true }.

	teapot
		POST: '/issues.edited' -> (Send message: #handleIssuesEdited: to: self);
		exception: MeError -> [ :ex :req | 
			logger logError: ex.
			TeaResponse badRequest body: { 'error' -> ex messageText } asDictionary ].
]

{ #category : #operations }
MeServer >> restart [
	self
		stop;
		start
]

{ #category : #operations }
MeServer >> start [
	self initializeTeapot.
	teapot start
]

{ #category : #operations }
MeServer >> stop [
	teapot stop
]

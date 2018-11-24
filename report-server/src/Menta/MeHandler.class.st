"
This is the abstract superclass of the handlers that subscribe to Github Hooks in a MeServer.
"
Class {
	#name : #MeHandler,
	#superclass : #Object,
	#category : #'Menta-Server'
}

{ #category : #operations }
MeHandler >> handleEvent: eventString action: actionString payload: payloadDictionary [

	^self subclassResponsibility
]

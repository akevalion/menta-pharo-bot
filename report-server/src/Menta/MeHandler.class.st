"
This is the abstract superclass of the handlers that subscribe to Github Webhooks in a MeServer.
"
Class {
	#name : #MeHandler,
	#superclass : #Object,
	#category : #'Menta-Server'
}

{ #category : #operations }
MeHandler >> handle: aMeGithubWebhook [

	^self subclassResponsibility
]

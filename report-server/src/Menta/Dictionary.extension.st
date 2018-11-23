Extension { #name : #Dictionary }

{ #category : #'*Menta' }
Dictionary >> chainedAt: anOrderedCollection [
	| value |
	value := self at: anOrderedCollection first.
	^ anOrderedCollection size > 1
		ifTrue: [ value chainedAt: anOrderedCollection allButFirst ]
		ifFalse: [ value ]
]

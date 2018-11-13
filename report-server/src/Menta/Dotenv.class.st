Class {
	#name : #Dotenv,
	#superclass : #Object,
	#instVars : [
		'dotenvFile'
	],
	#category : #'Menta-Dotenv'
}

{ #category : #accessing }
Dotenv >> config [

	| initial |
	initial := OSPlatform current environment asDictionary.
	
	self dotenvDictionary keysAndValuesDo: [ :key :value |
		(initial includesKey: key) ifFalse: [ 
			OSPlatform current environment setEnv: key value: value ] ]
]

{ #category : #accessing }
Dotenv >> dotenvDictionary [
	self dotenvFile exists
		ifFalse: [ ^ Dictionary new ].
	^ self dotenvFile contents lines
		inject: Dictionary new
		into: [ :dict :each | 
			| lineStream key value |
			lineStream := each readStream.
			key := lineStream upTo: $=.
			key ifEmpty: [ self error: 'dotenv: invalid variable name' ].
			value := self parseValue: lineStream upToEnd.
			dict
				at: key put: value;
				yourself ]
]

{ #category : #accessing }
Dotenv >> dotenvFile [
	^ dotenvFile ifNil: [ dotenvFile := '.env' asFileReference ]
]

{ #category : #accessing }
Dotenv >> dotenvFile: aFileReference [ 
	dotenvFile := aFileReference
]

{ #category : #accessing }
Dotenv >> parseValue: aString [
	| result |
	result := aString trim.

	((result beginsWith: '''') and: [ result endsWith: '''' ])
		ifTrue: [ ^ result allButFirst allButLast ].

	((result beginsWith: '"') and: [ result endsWith: '"' ])
		ifTrue: [ ^ Character lf join: (result allButFirst allButLast splitOn: '\n') ].
		
	^result
]

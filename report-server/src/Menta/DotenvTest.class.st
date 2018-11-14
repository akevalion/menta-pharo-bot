Class {
	#name : #DotenvTest,
	#superclass : #TestCase,
	#instVars : [
		'dotenvFileReference',
		'dotenv'
	],
	#category : #'Menta-Dotenv'
}

{ #category : #running }
DotenvTest >> dotenvWrite: aString [
	dotenvFileReference writeStreamDo: [ :stream | stream nextPutAll: aString ]
]

{ #category : #running }
DotenvTest >> setUp [
	super setUp.
	
	dotenvFileReference := (FileSystem memory / '.env') ensureCreateFile.
	dotenv := Dotenv new
		path: dotenvFileReference;
		yourself.

]

{ #category : #tests }
DotenvTest >> testBasic [
	self dotenvWrite: 'BASIC=basic'.

	self assert: dotenv variablesDictionary size equals: 1.
	self assert: (dotenv variablesDictionary at: 'BASIC') equals: 'basic'.
]

{ #category : #tests }
DotenvTest >> testDoubleQuoted [
	self dotenvWrite: 'DOUBLE_QUOTE="quoted"'.
	
	self assert: dotenv variablesDictionary size equals: 1.
	self assert: (dotenv variablesDictionary at: 'DOUBLE_QUOTE') equals: 'quoted'.
]

{ #category : #tests }
DotenvTest >> testEmpty [
	self dotenvWrite: 'EMPTY='.

	self assert: dotenv variablesDictionary size equals: 1.
	self assert: (dotenv variablesDictionary at: 'EMPTY') equals: ''.
]

{ #category : #tests }
DotenvTest >> testEmptyFile [
	self dotenvWrite: ''.
	
	self assert: dotenv variablesDictionary isEmpty
]

{ #category : #tests }
DotenvTest >> testMultipleLines [
	self dotenvWrite: 'DOUBLE_QUOTE="new\nline"'.

	self assert: dotenv variablesDictionary size equals: 1.
	self
		assert: (dotenv variablesDictionary at: 'DOUBLE_QUOTE')
		equals: 'new
line' withUnixLineEndings
]

{ #category : #tests }
DotenvTest >> testSingleQuoted [
	self dotenvWrite: 'SINGLE_QUOTE=''quoted'''.

	self assert: dotenv variablesDictionary size equals: 1.
	self assert: (dotenv variablesDictionary at: 'SINGLE_QUOTE') equals: 'quoted'.
]

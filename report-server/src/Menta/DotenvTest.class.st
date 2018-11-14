Class {
	#name : #DotenvTest,
	#superclass : #TestCase,
	#category : #'Menta-Dotenv'
}

{ #category : #tests }
DotenvTest >> testBasicVariable [
	| file dotenv |
	file := (FileSystem memory / '.env') writeStreamDo: [:stream | 
		stream nextPutAll: 'BASIC=basic' ]; yourself.
	
	dotenv := Dotenv new
		path: file;
		config.

	self assert: dotenv variablesDictionary size equals: 1.
	self assert: (dotenv variablesDictionary includesKey: 'BASIC').
	self assert: (dotenv variablesDictionary at: 'BASIC') equals: 'basic'.
]

{ #category : #tests }
DotenvTest >> testDoubleQuoted [
	| file dotenv |
	file := (FileSystem memory / '.env') writeStreamDo: [:stream | 
		stream nextPutAll: 'DOUBLE_QUOTE="quoted"' ];
		yourself.
	
	dotenv := Dotenv new
		path: file;
		config.

	self assert: dotenv variablesDictionary size equals: 1.
	self assert: (dotenv variablesDictionary at: 'DOUBLE_QUOTE') equals: 'quoted'.
]

{ #category : #tests }
DotenvTest >> testDoubleQuotedMultipleLines [
	| file dotenv |
	file := (FileSystem memory / '.env') writeStreamDo: [:stream | 
		stream nextPutAll: 'DOUBLE_QUOTE="new\nline"' ];
		yourself.
	
	dotenv := Dotenv new
		path: file;
		config.

	self assert: dotenv variablesDictionary size equals: 1.
	self assert: (dotenv variablesDictionary at: 'DOUBLE_QUOTE') equals: 'new
line' withUnixLineEndings
]

{ #category : #tests }
DotenvTest >> testEmptyFile [
	| file dotenv |
	file := (FileSystem memory / '.env') ensureCreateFile.
	dotenv := Dotenv new
		path: file;
		config.
	self assert: dotenv variablesDictionary isEmpty
]

{ #category : #tests }
DotenvTest >> testEmptyVariable [
	| file dotenv |
	file := (FileSystem memory / '.env') writeStreamDo: [:stream | 
		stream nextPutAll: 'EMPTY=' ]; yourself.

	dotenv := Dotenv new
		path: file;
		config.

	self assert: dotenv variablesDictionary size equals: 1.
	self assert: (dotenv variablesDictionary at: 'EMPTY') equals: ''.
]

{ #category : #tests }
DotenvTest >> testSingleQuoted [
	| file dotenv |
	file := (FileSystem memory / '.env') writeStreamDo: [:stream | 
		stream nextPutAll: 'SINGLE_QUOTE=''quoted''' ];
		yourself.
	
	dotenv := Dotenv new
		path: file;
		config.

	self assert: dotenv variablesDictionary size equals: 1.
	self assert: (dotenv variablesDictionary at: 'SINGLE_QUOTE') equals: 'quoted'.
]

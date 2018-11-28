"
This class represents the abstract credentials to authorize actions in the Github API using a ZnClient.
"
Class {
	#name : #MeGithubAppAbstractCredentials,
	#superclass : #Object,
	#instVars : [
		'githubAppName'
	],
	#category : #'Menta-Github API'
}

{ #category : #operations }
MeGithubAppAbstractCredentials >> applyTo: aZnClient [
	"Prepare a HTTP request (in the ZnClient) to authenticate as a Github App. Subclasses specialize.
	
	Source:
	https://developer.github.com/v3/#user-agent-required"

	aZnClient headerAt: 'User-Agent' put: self githubAppName
]

{ #category : #operations }
MeGithubAppAbstractCredentials >> githubAppName [
	^ githubAppName
]

{ #category : #operations }
MeGithubAppAbstractCredentials >> githubAppName: aString [
	githubAppName := aString
]

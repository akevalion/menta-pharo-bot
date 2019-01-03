"
This class represents the abstract credentials to authorize actions in the Github API using a ZnClient.
"
Class {
	#name : #MeGithubAppAbstractCredentials,
	#superclass : #Object,
	#instVars : [
		'githubApp'
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
MeGithubAppAbstractCredentials >> ensureFresh [
]

{ #category : #accessing }
MeGithubAppAbstractCredentials >> githubApp [
	^ githubApp
]

{ #category : #accessing }
MeGithubAppAbstractCredentials >> githubApp: aMeGithubApp [
	githubApp := aMeGithubApp
]

{ #category : #accessing }
MeGithubAppAbstractCredentials >> githubAppName [
	^ githubApp theName
]

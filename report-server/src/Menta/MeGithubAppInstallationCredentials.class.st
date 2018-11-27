"
Authenticating as an installation lets you perform actions in the API for that installation. Before authenticating as an installation, you must create an installation access token. These installation access tokens are used by GitHub Apps to authenticate.

Installation access tokens are scoped to the repositories an installation can access, have defined permissions set by the GitHub App, and expire after one hour.

To create an installation access token, include the JWT generated above in the Authorization header in the API request

Source: https://developer.github.com/apps/building-github-apps/authenticating-with-github-apps/#authenticating-as-an-installation
"
Class {
	#name : #MeGithubAppInstallationCredentials,
	#superclass : #MeGithubAppAbstractCredentials,
	#instVars : [
		'accessToken'
	],
	#category : #'Menta-Github API'
}

{ #category : #accessing }
MeGithubAppInstallationCredentials >> accessToken [
	^ accessToken
]

{ #category : #accessing }
MeGithubAppInstallationCredentials >> accessToken: anObject [
	accessToken := anObject
]

{ #category : #options }
MeGithubAppInstallationCredentials >> applyTo: aZnClient [
	super applyTo: aZnClient.
	aZnClient headerAt: 'Authorization' put: 'token ' , accessToken
]

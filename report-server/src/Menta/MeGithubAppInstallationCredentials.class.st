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
		'accessToken',
		'accessTokenExpireTime',
		'installationId'
	],
	#category : #'Menta-Github API'
}

{ #category : #accessing }
MeGithubAppInstallationCredentials >> accessToken [
	^ accessToken
]

{ #category : #accessing }
MeGithubAppInstallationCredentials >> accessTokenDuration [
	"By definition, GitHub app's installation access tokens are valid for 60 minutes."

	^ 60 minutes
]

{ #category : #options }
MeGithubAppInstallationCredentials >> applyTo: aZnClient [
	"Prepare a HTTP request (in the ZnClient) to authenticate as a Github App Installation.
	
	Source:
	https://developer.github.com/apps/building-github-apps/authenticating-with-github-apps/#authenticating-as-an-installation
	"

	super applyTo: aZnClient.
	aZnClient headerAt: 'Authorization' put: 'token ' , accessToken
]

{ #category : #operations }
MeGithubAppInstallationCredentials >> ensureFresh [
	self shouldRefreshAccessToken
		ifTrue: [ self refreshAccessToken ]
]

{ #category : #accessing }
MeGithubAppInstallationCredentials >> installationId: aNumber [
	installationId := aNumber
]

{ #category : #operations }
MeGithubAppInstallationCredentials >> newAccessToken [
	"Answer a new access token for the installation id."
	
	| payload |
	payload := MeGithubAPI new
		credentials: githubApp freshGithubAppCredentials;
		setRelativeUrlForInstallationAccessToken: installationId;
		post.
	^ (STON fromString: payload) at: 'token'

]

{ #category : #operations }
MeGithubAppInstallationCredentials >> refreshAccessToken [
	accessTokenExpireTime := DateAndTime now + self accessTokenDuration.
	accessToken := self newAccessToken
]

{ #category : #accessing }
MeGithubAppInstallationCredentials >> shouldRefreshAccessToken [
	"Tells if the accessTokenExpireTime is valid."

	^ accessToken isNil or: [ DateAndTime now > accessTokenExpireTime ]
]

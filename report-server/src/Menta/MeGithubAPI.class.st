"
This is a builder of a ZnClient instance that will request the Github API.

See: https://developer.github.com/v3/
"
Class {
	#name : #MeGithubAPI,
	#superclass : #Object,
	#instVars : [
		'relativeUrl',
		'credentials',
		'json',
		'entity'
	],
	#category : #'Menta-Github API'
}

{ #category : #tests }
MeGithubAPI class >> example [
	<example>
	| client |
	client := self new
		relativeUrl: 'app';
		credentials: (MeGithubAppCredentials withFreshJWT githubAppName: 'menta-pharo-bot'; yourself);
		newClient.
	client get inspect
]

{ #category : #accessing }
MeGithubAPI >> baseUrl [
	^ 'https://api.github.com/'
]

{ #category : #accessing }
MeGithubAPI >> credentials [
	^ credentials
]

{ #category : #accessing }
MeGithubAPI >> credentials: anObject [
	credentials := anObject
]

{ #category : #accessing }
MeGithubAPI >> json: aDictionary [
	entity := (ZnEntity text: (STON toJsonString: aDictionary))
		contentType: ZnMimeType applicationJson;
		yourself
]

{ #category : #'instance creation' }
MeGithubAPI >> newClient [
	"This is a build method that should be executed only when all settings were already passed to the builder (self)."

	| client |
	client := ZnClient new
		url: self url;
		headerAt: 'Accept' put: 'application/vnd.github.machine-man-preview+json';
		yourself.
	self credentials applyTo: client.
	entity
		ifNotNil: [ client
				entity: entity;
				contentType: entity contentType ].
	^ client
]

{ #category : #methods }
MeGithubAPI >> post [
	^ self newClient post
]

{ #category : #accessing }
MeGithubAPI >> relativeUrl [
	^ relativeUrl
]

{ #category : #accessing }
MeGithubAPI >> relativeUrl: aUrlEndingWithoutStartingSlash [
	relativeUrl := aUrlEndingWithoutStartingSlash
]

{ #category : #accessing }
MeGithubAPI >> setRelativeUrlForCommentsOnOwner: owner project: projectName number: issueNumber [
	self relativeUrl: 'repos/' , owner , '/' , projectName , '/issues/' , issueNumber asString , '/comments'
]

{ #category : #accessing }
MeGithubAPI >> setRelativeUrlForInstallationAccessToken: installationId [
	self relativeUrl: ('app/installations/{1}/access_tokens' format: {installationId})
]

{ #category : #accessing }
MeGithubAPI >> url [
	^ self baseUrl, self relativeUrl
]

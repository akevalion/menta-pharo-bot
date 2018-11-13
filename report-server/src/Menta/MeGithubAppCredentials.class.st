Class {
	#name : #MeGithubAppCredentials,
	#superclass : #IceSshCredentials,
	#category : #Menta
}

{ #category : #options }
MeGithubAppCredentials >> prepareRequest: aZnClient [
	| jws tokenString |
	jws := JsonWebSignature new
		algorithmName: 'RS256';
		payload:
			(JWTClaimsSet new
				at: 'iat' put: DateAndTime now asUnixTime;
				at: 'exp' put: DateAndTime now asUnixTime + (10 * 60);
				at: 'iss' put: (OSPlatform current environment asDictionary at: 'APP_ID');
				yourself).
	jws key: (OSPlatform current environment asDictionary at: 'PRIVATE_KEY').
	1 halt.
	tokenString := jws compactSerialized.
	aZnClient headerAt: 'Bearer' put: tokenString
]

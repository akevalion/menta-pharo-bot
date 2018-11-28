Class {
	#name : #Menta,
	#superclass : #Object,
	#category : #Menta
}

{ #category : #accessing }
Menta class >> repositoryPath [
	"We assume this image is located in something like 'menta-pharo-bot/server/build/'."
	
	^ FileLocator imageDirectory parent parent
]

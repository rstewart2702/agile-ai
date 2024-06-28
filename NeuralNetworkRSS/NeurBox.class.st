Class {
	#name : #NeurBox,
	#superclass : #Object,
	#instVars : [
		'localItem'
	],
	#category : #NeuralNetworkRSS
}

{ #category : #accessing }
NeurBox >> localItem [
	^ localItem
]

{ #category : #accessing }
NeurBox >> localItem: anObject [
	localItem := anObject
]

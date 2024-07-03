Class {
	#name : #NeurBox,
	#superclass : #Object,
	#instVars : [
		'localItem'
	],
	#classInstVars : [
		'defaultBox'
	],
	#category : #NeuralNetworkRSS
}

{ #category : #accessing }
NeurBox class >> defaultBox [
	^ defaultBox
]

{ #category : #accessing }
NeurBox class >> defaultBox: anObject [
	defaultBox := anObject
]

{ #category : #accessing }
NeurBox >> localItem [
	^ localItem
]

{ #category : #accessing }
NeurBox >> localItem: anObject [
	localItem := anObject
]

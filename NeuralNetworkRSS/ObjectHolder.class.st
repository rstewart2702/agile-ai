Class {
	#name : #ObjectHolder,
	#superclass : #Object,
	#instVars : [
		'objList'
	],
	#classInstVars : [
		'defList'
	],
	#category : #NeuralNetworkRSS
}

{ #category : #default }
ObjectHolder class >> defList [
    ^ defList.
]

{ #category : #setup }
ObjectHolder class >> defList: objRef [
  defList := objRef.
]

{ #category : #accessing }
ObjectHolder >> append: objRef [
  objList append: objRef.
]

{ #category : #accessing }
ObjectHolder >> at: objIdx [
    "Retrieve the object stored at objIdx."
    ^ objList at: objIdx.
]

{ #category : #accessing }
ObjectHolder >> at: objIdx put: objRef [
    "Retrieve the object stored at objIdx."
    objList at: objIdx put: objRef.
]

{ #category : #initialization }
ObjectHolder >> initialize [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
	objList := OrderedCollection new.
]

{ #category : #accessing }
ObjectHolder >> objList [
  ^ objList.
]

{ #category : #initialization }
ObjectHolder >> reset [ 
    self initialize.
]

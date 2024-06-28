Class {
	#name : #ActivationFunction,
	#superclass : #Object,
	#category : #NeuralNetworkRSS
}

{ #category : #evaluating }
ActivationFunction >> derivative: output [ 
  ^ self subclassResponsibility 
]

{ #category : #evaluating }
ActivationFunction >> eval: z [
  ^ self subclassResponsibility .
]

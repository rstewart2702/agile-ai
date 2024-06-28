Class {
	#name : #SigmoidAF,
	#superclass : #ActivationFunction,
	#category : #NeuralNetworkRSS
}

{ #category : #evaluating }
SigmoidAF >> derivative: output [ 
  ^ output * (1 - output).
]

{ #category : #evaluating }
SigmoidAF >> eval: z [
  ^ 1 / (1 + z negated exp).
]

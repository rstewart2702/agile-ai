Class {
	#name : #StepAF,
	#superclass : #ActivationFunction,
	#category : #NeuralNetworkRSS
}

{ #category : #evaluating }
StepAF >> derivative: output [ 
"N.B. Bergel notes, page 43, that this definition of the derivative of the step function is not mathematically precise, is not mathematically correct, since it should be 0 everywhere except at 0, where the derivative of the step function is UNDEFINED.  But he is apparently taking a kind of liberty which makes software implementation easier."
  ^ 1
]

{ #category : #evaluating }
StepAF >> eval: z [
  ^ (z > 0) ifTrue: [ 1 ] ifFalse: [ 0 ]
]

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
  "In contrast to the StepAF activation function, this is a smoothly-varying activation
  function which behaves very much like the setp activation function."
  ^ 1 / (1 + z negated exp).
]

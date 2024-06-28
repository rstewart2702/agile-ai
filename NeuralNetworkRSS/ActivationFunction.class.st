"
I provide the services of an activation function through messages 
eval: which calculates the value of the activation function for an input,
and derivative: which is the numerically calculated derivative value for an input.

We need to know the slope of the tangent to the curve at a point in order to do training, right?

The point of an activation function is to determine whether or not a neuron's calculated output is above a certain threshold value, correct?

So, the activation function is a kind of ""gatekeeper"" which prevents things from being output when they fail to meet criteria specified by the activation function.


"
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

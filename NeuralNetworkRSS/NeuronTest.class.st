Class {
	#name : #NeuronTest,
	#superclass : #TestCase,
	#category : #NeuralNetworkRSS
}

{ #category : #tests }
NeuronTest >> testTrainingAND [
  "Training af neuron to learn to be an AND gate.
   N.B. number of epochs has significantly increased.  
   The reason is that the sigmoid neron learns more slowly than a perceptron.
   
   Also notice the use of the closeTo:precision: message, since the response
   to a feed: message is a floating point number instead of an integer, 
   and therefore we must apply the semantics of floating point number comparison
   in this situation."
  | p |
  p := Neuron new.
  p weights: { -1. -1. }.
  p bias: 2.

  5000
    timesRepeat: [ 
	   p train: #(0 0) desiredOutput: 0.
	   p train: #(0 1) desiredOutput: 0.
	   p train: #(1 0) desiredOutput: 0.
	   p train: #(1 1) desiredOutput: 1.
	 ].

  self assert: ((p feed: #(0 0)) closeTo: 0 precision: 0.1).
  self assert: ((p feed: #(0 1)) closeTo: 0 precision: 0.1).
  self assert: ((p feed: #(1 0)) closeTo: 0 precision: 0.1).
  self assert: ((p feed: #(1 1)) closeTo: 1 precision: 0.1).

]

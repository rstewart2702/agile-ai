Class {
	#name : #NeurOR,
	#superclass : #Neuron,
	#category : #NeuralNetworkRSS
}

{ #category : #initialization }
NeurOR >> initialize [ 
  super initialize.
  self weights: #(1 1).
  self bias: -0.5.
  ^ self
]

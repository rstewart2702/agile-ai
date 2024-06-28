Class {
	#name : #NeurAND,
	#superclass : #Neuron,
	#category : #NeuralNetworkRSS
}

{ #category : #initialization }
NeurAND >> initialize [ 
  self weights: #(1 1).
  self bias: -1.5.
  ^ self
]

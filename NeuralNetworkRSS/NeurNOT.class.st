Class {
	#name : #NeurNOT,
	#superclass : #Neuron,
	#category : #NeuralNetworkRSS
}

{ #category : #initialization }
NeurNOT >> initialize [ 
  super initialize.
  self weights: #(-1).
  self bias: 0.5.
  ^ self
]

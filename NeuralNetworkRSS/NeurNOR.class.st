Class {
	#name : #NeurNOR,
	#superclass : #Neuron,
	#category : #NeuralNetworkRSS
}

{ #category : #initialization }
NeurNOR >> initialize [ 
  super initialize.
  self weights: #(-1 -1).
  self bias: 0.5.
  ^ self
]

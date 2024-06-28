Class {
	#name : #NeuronLayer,
	#superclass : #Object,
	#instVars : [
		'previousLayer',
		'nextLayer',
		'neurons'
	],
	#category : #NeuralNetworkRSS
}

{ #category : #evaluation }
NeuronLayer >> feed: someInputValues [
"Feed the neuron layer with some inputs."

| someOutputs |
someOutputs :=
  neurons collect: 
    [ :n | n feed: someInputValues ] 
  as: Array.

^ self isOutputLayer
    ifTrue: [ someOutputs ]
    ifFalse: [ nextLayer feed: someOutputs ].
]

{ #category : #initialization }
NeuronLayer >> initializeNbOfNeurons: nbOfNeurons nbOfWeights: nbOfWeights using: random [ 
"Main method to initialize a neuron layer
nbOfNeurons : number of neurons the layer should be made of
nbOfWeights : number of weights each neuron should have
random : a random number generator
"
| weights |

neurons := 
  (1 to: nbOfNeurons) 
  collect: 
    [ :i |
	   weights := 
	     (1 to: nbOfWeights) 
	     collect: [ :ii | random next * 4 - 2 ].
	   Neuron new
	     sigmoid;
	     weights: weights;
	     bias: (random next * 4 - 2)
	  ].
self learningRate: 0.1.    
]

{ #category : #testing }
NeuronLayer >> isOutputLayer [
"Tell whether or not the layer is the output layer (i.e., the last layer, right-most, in the network"

^ self nextLayer isNil.
]

{ #category : #accessing }
NeuronLayer >> learningRate: aLearningRate [
"Set the learning rate for all the neurons.
Note that this method should be called after configuring the
network and _not_ before."

self 
  assert:
    [ neurons notEmpty ]
  description:
    'learningRate:  should be invoked after configuring the layer.'.
neurons do: 
  [ :n | n learningRate: aLearningRate ].
]

{ #category : #accessing }
NeuronLayer >> neurons [
"Return the neurons I am composed of"
^ neurons
]

{ #category : #accessing }
NeuronLayer >> nextLayer [
"Return the next layer connected to me"
^ nextLayer
]

{ #category : #accessing }
NeuronLayer >> nextLayer: aLayer [
"set the next layer"

nextLayer := aLayer.
]

{ #category : #accessing }
NeuronLayer >> numberOfNeurons [
"Return the number of neurons in the layer"
^ neurons size
]

{ #category : #accessing }
NeuronLayer >> previousLayer [
"Return the previous layer connected to me"
^ previousLayer.
]

{ #category : #accessing }
NeuronLayer >> previousLayer: aLayer [
"Set the previous layer"
previousLayer := aLayer.
]

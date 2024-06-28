Class {
	#name : #NeuronLayerTest,
	#superclass : #TestCase,
	#category : #NeuralNetworkRSS
}

{ #category : #tests }
NeuronLayerTest >> testBasic [ 
"Simple test to create a new neuron layer, composed of three neurons.
Each of the neurons has four weights and one bias.  The weights and biases
are initialized using the random number generator r."
| nl result r |
r := Random seed: 42.
nl := NeuronLayer new.
nl initializeNbOfNeurons: 3 nbOfWeights: 4 using: r.

self assert: nl isOutputLayer.

result := nl feed: #(1 2 3 4).

self assert: result size equals: 3.

result
  with: #(0.03700050130978758 
          0.9051275824569505 
          0.9815269659126287)
  do: [ :res :test | self assert: (res closeTo: test precision: 0.0000000001 ) ].
]

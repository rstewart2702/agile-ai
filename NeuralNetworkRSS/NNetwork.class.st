"
Regarding back-propagation:
backward propagation of errors into a neural network starts with sending 
message NNetwork>>#backwardPropagateError: as it is merely the 
outermost ""shell"" which starts the (recursive) process of 
backward propagation by sending backwardPropagateError: to the 
outputLayer.

So, that should make it clear that the propagation is working
""backwards"" from the outputLayer, right?
"
Class {
	#name : #NNetwork,
	#superclass : #Object,
	#instVars : [
		'layers',
		'errors',
		'precisions'
	],
	#category : #NeuralNetworkRSS
}

{ #category : #adding }
NNetwork >> addLayer: aNeuronLayer [
"Add a neural layer. The added layer is linked to the already added layers."
layers ifNotEmpty: [ 
	aNeuronLayer previousLayer: layers last.
	layers last nextLayer: aNeuronLayer ].
layers add: aNeuronLayer.
]

{ #category : #evaluation }
NNetwork >> backwardPropagateError: expectedOutputs [
  "ExpectedOutputs corresponds to the outputs we are training the network against.
   This starts backward-propagation by sending 
     backwardPropagateError: expectedOutputs
   to the outputLayer of the NNetwork."
  self outputLayer backwardPropagateError: expectedOutputs.
]

{ #category : #configuration }
NNetwork >> configure: nbOfInputs hidden: nbOfNeurons1 hidden: nbOfNeurons2 nbOfOutputs: nbOfOutput [
"Configure the network with the given parameters.
NOTE:  In this case, the network has only two hidden layers."
| random |
random := Random seed: 42.
self 
  addLayer: (NeuronLayer new 
               initializeNbOfNeurons: nbOfNeurons1
               nbOfWeights: nbOfInputs 
               using: random).
self 
  addLayer: (NeuronLayer new 
               initializeNbOfNeurons: nbOfNeurons2
               nbOfWeights: nbOfNeurons1
               using: random).
self
  addLayer: (NeuronLayer new
               initializeNbOfNeurons: nbOfOutput 
               nbOfWeights: nbOfNeurons2
               using: random).
]

{ #category : #configuration }
NNetwork >> configure: nbOfInputs hidden: nbOfNeurons nbOfOutputs: nbOfOutput [
"Configure the network with the given parameters.
The network has only one hidden layer."
| random |
random := Random seed: 42.
self 
  addLayer: (NeuronLayer new 
               initializeNbOfNeurons: nbOfNeurons 
               nbOfWeights: nbOfInputs 
               using: random).
self
  addLayer: (NeuronLayer new
               initializeNbOfNeurons: nbOfOutput 
               nbOfWeights: nbOfNeurons 
               using: random).
]

{ #category : #evaluation }
NNetwork >> feed: someInputValues [
"Feed the first layer with the provided inputs."
^ layers first feed: someInputValues
]

{ #category : #initialization }
NNetwork >> initialize [ 
super initialize.
layers := OrderedCollection new.
errors := OrderedCollection new.
precisions := OrderedCollection new.
]

{ #category : #accessing }
NNetwork >> learningRate: aLearningRate [
"Set the learning rate for all the layers"
layers do: [ :l | l learningRate: aLearningRate ].
]

{ #category : #helpers }
NNetwork >> numberOfInputs [
  "Return the number of inputs the network has."
  ^ layers first neurons size
]

{ #category : #helpers }
NNetwork >> numberOfNeurons [
  "Return the total number of neurons the network has."
  ^ (layers collect: #numberOfNeurons) sum
]

{ #category : #accessing }
NNetwork >> numberOfOutputs [
"Return the number of outputs of the network."
^ layers last numberOfNeurons
]

{ #category : #accessing }
NNetwork >> outputLayer [
  "Return the output layer, which is also the last layer."
  ^ layers last.
]

{ #category : #training }
NNetwork >> predict: inputs [
  "Make a prediction.  This method assumes that the number of outputs 
   is the same as the number of different values the network can output."
  | outputs |
  outputs := self feed: inputs.
  ^ (outputs indexOf: (outputs max)) - 1
]

{ #category : #training }
NNetwork >> train: someInputs desiredOutputs: desiredOutputs [
  "Train the neural network with a set of inputs and some expected output."
  self feed: someInputs.
  self backwardPropagateError: desiredOutputs.
  self updateWeight: someInputs.
]

{ #category : #training }
NNetwork >> train: train nbEpochs: nbEpochs [
"Train the network using the train dataset."
  | sumError outputs expectedOutput epochPrecision t |
  1 to: nbEpochs do: 
    [ :epoch |
	   sumError := 0.
	   epochPrecision := 0.
	   train do: 
	     [ :row |
		    outputs := self feed: row allButLast.
		    expectedOutput := 
		      (1 to: self numberOfOutputs) 
		      collect: [ :notUsed | 0 ].
		    expectedOutput at: (row last) + 1 put: 1.
		    (row last = (self predict: row allButLast))
		      ifTrue: [ epochPrecision := epochPrecision + 1 ].
		    t := 
            (1 to: expectedOutput size)
            collect: [ :i | ((expectedOutput at: i) - (outputs at: i)) squared ].
          sumError := sumError + t sum.
          self backwardPropagateError: expectedOutput.
          self updateWeight: row allButLast.
        ].
      errors add: sumError.
      precisions add: (epochPrecision / train size) asFloat.
    ].
		
]

{ #category : #evaluation }
NNetwork >> updateWeight: initialInputs [
  "Update the weights of the neurons using the initial inputs."
  layers first updateWeight: initialInputs.
]

{ #category : #training }
NNetwork >> viewLearningCurve [
  "Draw the error and precision curve."
  | b ds |
  "No need to draw anything if the network has not been run."
  errors 
    ifEmpty: [ ^ RTView new
	              add: (RTLabel elementOn: 'Should first run the network.');
	              yourself ].
  b := RTDoubleGrapher new.

  "We define the size of the charting area"
  b extent: 500 @ 300.
  ds := RTData new.
  "A simple optimization that Roassal offers."
  ds samplingIfMoreThan: 2000.
  "No need of dots, simply a curve."
  ds noDot; connectColor: Color blue.
  ds points: (errors collectWithIndex: [ :y :i | i -> y ]).
  ds x: #key.
  ds y: #value.
  ds dotShape rectangle color: Color blue.
  b add: ds.
  ds := RTData new.
  ds samplingIfMoreThan: 2000.
  ds noDot.
  ds connectColor: Color red.
  ds points: (precisions collectWithIndex: [ :y :i | i-> y ]).
  ds x: #key.
  ds y: #value.
  ds dotShape rectangle color: Color blue.
  b addRight: ds.
  b axisX noDecimal; title: 'Epoch'.
  b axisY title: 'Error'.
  b axisYRight title: 'Precision'; color: Color red.
  ^ b.
]

{ #category : #training }
NNetwork >> viewLearningCurveIn: composite [
  <gtInspectorPresentationOrder: -10>
  composite roassal2
    title: 'Learning';
    initializeView: [ self viewLearningCurve ].
]

{ #category : #training }
NNetwork >> viewNetwork [
  | b lb |
  b := RTMondrian new.
  
  b nodes: layers 
    forEach: [ :aLayer | 
	            b shape circle size: 20.
	            b nodes: aLayer neurons.
	            b layout verticalLine. ].

  b shape arrowedLine; withShorterDistanceAttachPoint.
  b edges connectTo: #nextLayer.
  b layout horizontalLine gapSize: 30; center.

  b build.

  lb := RTLegendBuilder new.
  lb view: b view.
  lb addText: self numberOfNeurons asString, ' neurons'.
  lb addText: self numberOfInputs asString, ' inputs'.
  lb build.
  ^ b view.
]

{ #category : #training }
NNetwork >> viewNetworkIn: composite [ 
  <gtInspectorPresentationOrder: -5>
  composite roassal2 
    title: 'Network';
    initializeView: [ self viewNetwork ].
]

Class {
	#name : #PerceptronTest1,
	#superclass : #TestCase,
	#instVars : [
		'locDigitalComparator'
	],
	#category : #NeuralNetworkRSS
}

{ #category : #tests }
PerceptronTest1 >> digitalComparator: inputs [
  ^ locDigitalComparator feed: inputs.
]

{ #category : #'instance creation' }
PerceptronTest1 >> newNeuron [ 
  "Return a new neuron."
  ^ Neuron new step
]

{ #category : #running }
PerceptronTest1 >> setUp [
	super setUp.
	locDigitalComparator := NeurCOMP new.
	
	"Put here a common initialization logic for tests"
]

{ #category : #tests }
PerceptronTest1 >> testAND [ 
  | p |
  p := self newNeuron.
  p weights: #(1 1).
  p bias: -1.5.

  self assert: (p feed: #(0 0)) equals: 0.
  self assert: (p feed: #(0 1)) equals: 0.
  self assert: (p feed: #(1 0)) equals: 0.
  self assert: (p feed: #(1 1)) equals: 1.

]

{ #category : #tests }
PerceptronTest1 >> testDigitalComparator [
  self assert: (locDigitalComparator feed: #(0 0)) equals: #(0 1 0).
  self assert: (locDigitalComparator feed: #(1 1)) equals: #(0 1 0).
  self assert: (locDigitalComparator feed: #(1 0)) equals: #(0 0 1).
  self assert: (locDigitalComparator feed: #(0 1)) equals: #(1 0 0).
  
]

{ #category : #tests }
PerceptronTest1 >> testNOR [
  | p |
  p := self newNeuron.
  p weights: #(-1 -1).
  p bias: 0.5.

  self assert: (p feed: #(0 0)) equals: 1.
  self assert: (p feed: #(0 1)) equals: 0.
  self assert: (p feed: #(1 0)) equals: 0.
  self assert: (p feed: #(1 1)) equals: 0.
]

{ #category : #tests }
PerceptronTest1 >> testNOT [ 
  | p |
  p := self newNeuron.
  p weights: #(-1).
  p bias: 0.5.

  self assert: (p feed: #(1)) equals: 0.
  self assert: (p feed: #(0)) equals: 1.
]

{ #category : #tests }
PerceptronTest1 >> testOR [
  | p |
  p := self newNeuron.
  p weights: #(1 1).
  p bias: -0.5.
  self assert: (p feed: #(0 0)) equals: 0.
  self assert: (p feed: #(0 1)) equals: 1.
  self assert: (p feed: #(1 0)) equals: 1.
  self assert: (p feed: #(1 1)) equals: 1.
]

{ #category : #tests }
PerceptronTest1 >> testSmallExample [ 
  | p result |
  "N.B. need to be sure that the object derived by self newNeuron is the object
   we *think* it is!"
  p := self newNeuron.
  p weights: #(1 2).
  p bias: -2.
  result := p feed: #(5 2).
  self assert: result equals: 1.
  "self assert: result closeTo: 1 precision: 1e-05."
]

{ #category : #tests }
PerceptronTest1 >> testTrainingNOT [
  | p |
  p := self newNeuron.
  p weights: #(-1).
  p bias: 2.
  40 timesRepeat: [
    p train: #(0) desiredOutput: 1.
    p train: #(1) desiredOutput: 0.
  ].
  self assert: (p feed: #(0)) equals: 1.
  self assert: (p feed: #(1)) equals: 0.
]

{ #category : #tests }
PerceptronTest1 >> testTrainingOR [ 
  | p |
  p := self newNeuron.
  p weights: #(-1 -1).
  p bias: 2.

  40 timesRepeat: [ 
	 p train: #(0 0) desiredOutput: 0.
 	 p train: #(0 1) desiredOutput: 1. 
	 p train: #(1 0) desiredOutput: 1.
 	 p train: #(1 1) desiredOutput: 1.
  ].

  self assert: (p feed: #(0 0)) equals: 0.
  self assert: (p feed: #(0 1)) equals: 1.
  self assert: (p feed: #(1 0)) equals: 1.
  self assert: (p feed: #(1 1)) equals: 1.
]

{ #category : #tests }
PerceptronTest1 >> testTrainingOR: epochs [
  "This doesn't really conform to the notion of the testing classes, but it 
   can still be invoked from a playground or workspace, and if it executes without raising
   an exception, then the test passes...

""What is the necessary minimum number of epochs to train p?""
pt := PerceptronTest1 new.
pt setUp.
pt testTrainingOR: 31. ""The answer seems to be 32...""
"
  | p |
  p := self newNeuron.
  p weights: #(-1 -1).
  p bias: 2.

  epochs timesRepeat: [ 
	 p train: #(0 0) desiredOutput: 0.
 	 p train: #(0 1) desiredOutput: 1. 
	 p train: #(1 0) desiredOutput: 1.
 	 p train: #(1 1) desiredOutput: 1.
  ].

  self assert: (p feed: #(0 0)) equals: 0.
  self assert: (p feed: #(0 1)) equals: 1.
  self assert: (p feed: #(1 0)) equals: 1.
  self assert: (p feed: #(1 1)) equals: 1.
]

{ #category : #tests }
PerceptronTest1 >> testWrongFeeding [ 
  | p |
  p := self newNeuron.
  p weights: #(-1).
  p bias: 0.5.
  
  "should:raise: succeeds when the block in question causes an error to be ""raised?""".
  self should: [ p feed: #(1 1) ] raise: Error.
]

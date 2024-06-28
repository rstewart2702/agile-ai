"
I am a Neuron/Perceptron.

I have weights, and a bias
I am fed inputs, to provide a value (with the feed: message)

I also have an activation function, and there are two choices for the activation function:
  choose a sigmoid activation function via message
    sigmoid
  OR
  choose a step activation function via message 
    step

The sigmoid activation function is continuous and differentiable everywhere, but the
step activation function is NOT continuous, and is not differentiable at input of 0. 

    Instance Variables
	bias:		a number
	learningRate:		a number
	weights:		an array of numbers


    Implementation Points
Initial implementation did *not* include learningRate.  That was added by section 1.7 in 
Prof. Bergel's book.

Further:  On the class-side, we have provided methods to go with the scripts
presented in the book.  There are some irritating subtleties about the way in
which array literals are handled, and this explained much about why it is such
a bad idea to pass array-literals around, since compiled methods and blocks 
make such structures persist, even after they have been modified.

For more on this, see (Neuron class)>>accuracyExample2_1, versus the other 
example methods, which help illustrate the issue.
"
Class {
	#name : #Neuron,
	#superclass : #Object,
	#instVars : [
		'weights',
		'bias',
		'learningRate',
		'activationFunction'
	],
	#category : #NeuralNetworkRSS
}

{ #category : #examples }
Neuron class >> accuracyExample [
  | learningCurve f r p anX anY trainedOutput nbOfGood nbOfTries g d realOutput w |
  learningCurve := OrderedCollection new.
  f := [ :x | (-2 * x) - 3 ].
  0 to: 2000 by: 10 do: 
    [ :nbOfTrained |
	   r := Random new seed: 42.
	   p := self new.
	   "p weights: #(1 2)."
	   w := Array new: 2.
	   w at: 1 put: 1. w at: 2 put: 2.
	   p weights: w.
	   p bias: -1.
	   
	   nbOfTrained timesRepeat: [ 
		  anX := (r nextInt: 50 ) - 25.
		  anY := (r nextInt: 50 ) - 25. 
		  trainedOutput := (f value: anX) >= anY ifTrue: [1] ifFalse: [0].
		  p train: (Array with: anX with: anY) desiredOutput: trainedOutput  
		].
	
	  nbOfGood := 0.
	  nbOfTries := 1000.
	  nbOfTries timesRepeat: [ 
		 anX := (r nextInt: 50) - 25.
		 anY := (r nextInt: 50) - 25.
		 realOutput := (f value: anX) >= anY ifTrue: [1] ifFalse: [0].
		 ((p feed: { anX. anY }) - realOutput) abs < 0.2 
		    ifTrue: [  nbOfGood := nbOfGood + 1 ].
	  ].
     learningCurve add: { nbOfTrained . (nbOfGood / nbOfTries) }.
   ].
  
  g := RTGrapher new.
  d := RTData new.
  d noDot.
  d connectColor: Color blue.
  d points: learningCurve.
  d x: #first.
  d y: #second.
  g add: d.
  g axisY title: 'Precision'.
  g axisX noDecimal; title: 'Training iteration'.
  ^ g
]

{ #category : #examples }
Neuron class >> accuracyExample2 [
| learningCurve f p r anX anY trainedOutput nbOfGood nbOfTries realOutput g d |
"What is going on with the way Roassal2 works?"
learningCurve := OrderedCollection new.
f := [ :x | (-2 * x) - 3 ].
0 to: 2000 by: 10 do: [ :nbOfTrained |
  r := Random new seed: 42.
  p := self new.
  "There is some kind of subtle semantic or compiler issue with 
  passing in a literal array of integers.
  The array structure is allowed to persist, and then it gets changed,
  instead of a new array structure being allocated each time this 
  method executes."
  "p weights: #(1 2)."
  p weights: { 1. 2. }. 
  p bias: -1.
  nbOfTrained timesRepeat: [
    anX := (r nextInt: 50) - 25.
    anY := (r nextInt: 50) - 25.
    trainedOutput := (f value: anX) >= anY ifTrue: [1] ifFalse: [0].
    p train: (Array with: anX with: anY) desiredOutput:
    trainedOutput ].
  nbOfGood := 0.
  nbOfTries := 1000.
  nbOfTries timesRepeat: [
    anX := (r nextInt: 50) - 25.
    anY := (r nextInt: 50)- 25.
    realOutput := (f value: anX) >= anY ifTrue: [1] ifFalse: [0].
    ((p feed: { anX . anY }) - realOutput) abs < 0.2
      ifTrue: [ nbOfGood := nbOfGood + 1 ].
  ].
  learningCurve add: { nbOfTrained . (nbOfGood / nbOfTries) }.
].
g := RTGrapher new.
d := RTData new.
d noDot.
d connectColor: Color blue.
d points: learningCurve.
d x: #first.
d y: #second.

g add: d.
g axisY title: 'Precision'.
g axisX noDecimal; title: 'Training iteration'.
^ g 
]

{ #category : #examples }
Neuron class >> accuracyExample2_1 [
| learningCurve f p r anX anY trainedOutput nbOfGood nbOfTries realOutput g d  |
"What is going on with the way Roassal2 works?"
learningCurve := OrderedCollection new.
f := [ :x | (-2 * x) - 3 ].
0 to: 2000 by: 10 do: [ :nbOfTrained |
r := Random new seed: 42.
p := self new.
"There is some kind of subtle semantic or compiler issue with 
passing in a literal array of integers.
The array structure is allowed to persist, and then it gets changed,
instead of a new array structure being allocated each time this 
method executes.

This is why we hit errors in Pharo9 when trying to send at:put: to 
so-called array-constants:  the Pharo organization made the 
policy decision that such things should be forbidden, and so
they result in run-time errors, given the late-bound nature of
Smalltalk programs...

In this incarnation of Pharo, Pharo 8, the same array instance is 
retained for this method, and the 'pointer' to it is handed off to 
the Neuron>>weights: method each time this is called.  What is worse 
is that the training methods perturb this same array, and this is why 
the data move around between method invocations.  And it's all because 
the subtle semantics of expressions like #(1 2) mean that the compiler 
takes liberties with such expressions, liberties it does not take with 
expressions like 
  { 1. 2. }
#(1 2) gets compiled down to a constant, while { 1. 2. } should not, eh?

It is easiest to see this happening by examining the bytecode generated by
the compiler, in an inspector.  For example, evaluate this in a playground/workspace:
  ((Neuron class) >> #accuracyExample2_1 ) method inspect.
"
p weights: #(1 2).

p bias: -1.
nbOfTrained timesRepeat: [
anX := (r nextInt: 50) - 25.
anY := (r nextInt: 50) - 25.
trainedOutput := (f value: anX) >= anY ifTrue: [1] ifFalse: [0].
p train: (Array with: anX with: anY) desiredOutput:
trainedOutput ].
nbOfGood := 0.
nbOfTries := 1000.
nbOfTries timesRepeat: [
anX := (r nextInt: 50) - 25.
anY := (r nextInt: 50)- 25.
realOutput := (f value: anX) >= anY ifTrue: [1] ifFalse: [0].
((p feed: { anX . anY }) - realOutput) abs < 0.2
ifTrue: [ nbOfGood := nbOfGood + 1 ].
].
learningCurve add: { nbOfTrained . (nbOfGood / nbOfTries) }.
].
g := RTGrapher new.
d := RTData new.
d noDot.
d connectColor: Color blue.
d points: learningCurve.
d x: #first.
d y: #second.

g add: d.
g axisY title: 'Precision'.
g axisX noDecimal; title: 'Training iteration'.
^ g
]

{ #category : #'as yet unclassified' }
Neuron class >> accuracyIters: iterNumber points: ptsNumber seeded: seedVal [
  | learningCurve f r p anX anY trainedOutput nbOfGood nbOfTries g d |
  learningCurve := OrderedCollection new.
  f := [ :x | (-2 * x) - 3 ].
  0 to: 2000 by: 10 do: 
    [ :nbOfTrained |
	   r := Random new seed: seedVal ]
]

{ #category : #examples }
Neuron class >> perceptronTraining2 [
"Messy script for figure 1-13 of the Bergel book.
Note:  the RTGrapher instance returned to the caller/sender
should send the build message to the RTGrapher, so that when
  Neuron perceptronTraining2 build
is used in a Playground window, the RTGrapher will be drawn or rendered
in the Playground window."
| f p r anX anY designedOutput testPoints g d2 d |
f := [ :x | (-2 * x) - 3 ].
"Checking my Smalltalk reasoning:  we indeed want to create a Neuron1,
and then tell it to do several things."
"self assert: self equals: Neuron."
p := self new.
p weights: { 1 . 2 }.
p bias: -1.
r := Random new seed: 42.
"We are training the perceptron"
500 timesRepeat: [
  anX := (r nextInt: 50) - 25.
  anY := (r nextInt: 50) - 25.
  designedOutput := 
    (f value: anX) >= anY
      ifTrue: [ 1 ] 
      ifFalse: [ 0 ].
  p train: { anX . anY } desiredOutput: designedOutput
].

"Test points"
testPoints := OrderedCollection new.
2000 timesRepeat: 
  [ testPoints add: { ((r nextInt: 50) - 25) . ((r nextInt: 50) - 25) } ].
g := RTGrapher new.
d := RTData new.
d dotShape
  color: 
    [ :point | 
	   (p feed: point) > 0.5
        ifTrue: [ Color red trans ]
        ifFalse: [ Color blue trans ] ].
d points: testPoints.
d x: #first.
d y: #second.
g add: d.
d2 := RTData new.
d2 noDot.
d2 connectColor: Color red.
d2 points: (-15 to: 15 by: 0.1).
d2 y: f.
d2 x: #yourself.
g add: d2.
"must return the RTGrapher, and it can be sent the build message by 
the playground which invokes it, eh?"
^ g
]

{ #category : #examples }
Neuron class >> perceptronTraining2Seeded: seedNumber [
"Messy script for figure 1-13 of the Bergel book.
Note:  the RTGrapher instance returned to the caller/sender
should send the build message to the RTGrapher, so that when
  Neuron perceptronTraining2 build
is used in a Playground window, the RTGrapher will be drawn or rendered
in the Playground window."
| f p r anX anY designedOutput testPoints g d2 d |
f := [ :x | (-2 * x) - 3 ].
"Checking my Smalltalk reasoning:  we indeed want to create a Neuron1,
and then tell it to do several things."
"self assert: self equals: Neuron."
p := self new.
p weights: { 1 . 2 }.
p bias: -1.
r := Random new seed: seedNumber.
"We are training the perceptron"
500 timesRepeat: [
  anX := (r nextInt: 50) - 25.
  anY := (r nextInt: 50) - 25.
  designedOutput := 
    (f value: anX) >= anY
      ifTrue: [ 1 ] 
      ifFalse: [ 0 ].
  p train: { anX . anY } desiredOutput: designedOutput
].

"Test points"
testPoints := OrderedCollection new.
2000 timesRepeat: 
  [ testPoints add: { ((r nextInt: 50) - 25) . ((r nextInt: 50) - 25) } ].
g := RTGrapher new.
d := RTData new.
d dotShape
  color: 
    [ :point | 
	   (p feed: point) > 0.5
        ifTrue: [ Color red trans ]
        ifFalse: [ Color blue trans ] ].
d points: testPoints.
d x: #first.
d y: #second.
g add: d.
d2 := RTData new.
d2 noDot.
d2 connectColor: Color red.
d2 points: (-15 to: 15 by: 0.1).
d2 y: f.
d2 x: #yourself.
g add: d2.
"must return the RTGrapher, and it can be sent the build message by 
the playground which invokes it, eh?"
^ g
]

{ #category : #examples }
Neuron class >> perceptronTraining2iters: iterNumber points: ptsNumber seeded: seedNumber [
"Messy script for figure 1-13 of the Bergel book.
Note:  the RTGrapher instance returned to the caller/sender
should send the build message to the RTGrapher, so that when
  Neuron perceptronTraining2 build
is used in a Playground window, the RTGrapher will be drawn or rendered
in the Playground window."
| f p r anX anY designedOutput testPoints g d2 d |
f := [ :x | (-2 * x) - 3 ].
"Checking my Smalltalk reasoning:  we indeed want to create a Neuron1,
and then tell it to do several things."
"self assert: self equals: Neuron."
p := self new.
p weights: { 1 . 2 }.
p bias: -1.
r := Random new seed: seedNumber.
"We are training the perceptron"
iterNumber timesRepeat: [
  anX := (r nextInt: 50) - 25.
  anY := (r nextInt: 50) - 25.
  designedOutput := 
    (f value: anX) >= anY
      ifTrue: [ 1 ] 
      ifFalse: [ 0 ].
  p train: { anX . anY } desiredOutput: designedOutput
].

"Test points"
testPoints := OrderedCollection new.
ptsNumber timesRepeat: 
  [ testPoints add: { ((r nextInt: 50) - 25) . ((r nextInt: 50) - 25) } ].
g := RTGrapher new.
d := RTData new.
d dotShape
  color: 
    [ :point | 
	   (p feed: point) > 0.5
        ifTrue: [ Color red trans ]
        ifFalse: [ Color blue trans ] ].
d points: testPoints.
d x: #first.
d y: #second.
g add: d.
d2 := RTData new.
d2 noDot.
d2 connectColor: Color red.
d2 points: (-15 to: 15 by: 0.1).
d2 y: f.
d2 x: #yourself.
g add: d2.
"must return the RTGrapher, and it can be sent the build message by 
the playground which invokes it, eh?"
^ g
]

{ #category : #examples }
Neuron class >> perceptronTraining2iters: iterNumber seeded: seedNumber [
"Messy script for figure 1-13 of the Bergel book.
Note:  the RTGrapher instance returned to the caller/sender
should send the build message to the RTGrapher, so that when
  Neuron perceptronTraining2 build
is used in a Playground window, the RTGrapher will be drawn or rendered
in the Playground window."
| f p r anX anY designedOutput testPoints g d2 d |
f := [ :x | (-2 * x) - 3 ].
"Checking my Smalltalk reasoning:  we indeed want to create a Neuron1,
and then tell it to do several things."
"self assert: self equals: Neuron."
p := self new.
p weights: { 1 . 2 }.
p bias: -1.
r := Random new seed: seedNumber.
"We are training the perceptron"
iterNumber timesRepeat: [
  anX := (r nextInt: 50) - 25.
  anY := (r nextInt: 50) - 25.
  designedOutput := 
    (f value: anX) >= anY
      ifTrue: [ 1 ] 
      ifFalse: [ 0 ].
  p train: { anX . anY } desiredOutput: designedOutput
].

"Test points"
testPoints := OrderedCollection new.
5000 timesRepeat: 
  [ testPoints add: { ((r nextInt: 50) - 25) . ((r nextInt: 50) - 25) } ].
g := RTGrapher new.
d := RTData new.
d dotShape
  color: 
    [ :point | 
	   (p feed: point) > 0.5
        ifTrue: [ Color red trans ]
        ifFalse: [ Color blue trans ] ].
d points: testPoints.
d x: #first.
d y: #second.
g add: d.
d2 := RTData new.
d2 noDot.
d2 connectColor: Color red.
d2 points: (-15 to: 15 by: 0.1).
d2 y: f.
d2 x: #yourself.
g add: d2.
"must return the RTGrapher, and it can be sent the build message by 
the playground which invokes it, eh?"
^ g
]

{ #category : #accessing }
Neuron >> bias [ 
    "Return the bias of the neuron"
    ^ bias
]

{ #category : #accessing }
Neuron >> bias: aNumber [
    "Set bias of the neuron"
    bias := aNumber
]

{ #category : #evaluation }
Neuron >> feed: inputs [
    | z |
    "with:collect: is used to calculate the inner-product of
    the inputs and the weights, and then the inner-product is 
    ""biased"" by adding in the bias."
    z := (inputs with: weights collect: [ :x :w | x * w ]) sum + bias.
    ^ activationFunction eval: z
]

{ #category : #'as yet unclassified' }
Neuron >> fixedWeights [
  self weights: #(1 2).
]

{ #category : #initialization }
Neuron >> initialize [ 
  super initialize.
  learningRate := 0.1.
  self sigmoid  "Ah! so by default, we use the sigmoid activation function, eh?"
]

{ #category : #accessing }
Neuron >> learningRate [
  "Return the learning rate of the neuron."
	^ learningRate
]

{ #category : #accessing }
Neuron >> learningRate: aLearningRateAsFloat [
  "Set the leraning rate of the neuron. The argument should be a small floating value.
For example, 0.01."

	learningRate := aLearningRateAsFloat
]

{ #category : #utility }
Neuron >> sigmoid [
  "Use the sigmoid activation function"
  activationFunction := SigmoidAF new
]

{ #category : #stepping }
Neuron >> step [
  "Use the step activation function"
  activationFunction := StepAF new.
]

{ #category : #'as yet unclassified' }
Neuron >> train: inputs desiredOutput: desiredOutput [
  | diff output delta |
  "What is the weight adjustment and bias adjustment supposed to achieve?"
  output := self feed: inputs.
  diff := desiredOutput - output.
  delta := diff * (activationFunction derivative: output).

  inputs withIndexDo: 
    [ :anInput :index |
	    weights at: index put: ((weights at: index) + (learningRate * delta * anInput)) ].
  bias := bias + (learningRate * delta)

]

{ #category : #accessing }
Neuron >> weights [
    "Return the weights of the neuron."
    ^ weights
]

{ #category : #accessing }
Neuron >> weights: someWeightsAsNumbers [
	"Set the weights of the neuron.  Takes a collection of numbers as the argument."
	"scope: class-variables  &  instance-variables"	
   weights := someWeightsAsNumbers.
]

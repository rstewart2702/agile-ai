Class {
	#name : #NeurExample,
	#superclass : #Neuron,
	#classInstVars : [
		'learningCurve',
		'f',
		'p',
		'r',
		'anX',
		'anY',
		'trainedOutput',
		'nbOfGood',
		'nbOfTries',
		'realOutput',
		'g',
		'd'
	],
	#category : #NeuralNetworkRSS
}

{ #category : #'as yet unclassified' }
NeurExample class >> accuracyExample2 [
"| learningCurve f p r anX anY trainedOutput nbOfGood nbOfTries realOutput g d |"
" Idea:  there is some state which persists in the playground which does not when
         I send the message to the Neuron class, so I will retain that local state 
         inside the 'class-representing object,' (Neuron class)..."
"What is going on with the way Roassal2 works?"
learningCurve 
  ifNil: [ learningCurve := OrderedCollection new. ]
  ifNotNil: [ learningCurve removeAll ].
"learningCurve := OrderedCollection new."
f := [ :x | (-2 * x) - 3 ].
0 to: 2000 by: 10 do: [ :nbOfTrained |
r := Random new seed: 42.
p := self new.
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

{ #category : #accessing }
NeurExample class >> learningCurve [
  ^ learningCurve
]

{ #category : #accessing }
NeurExample class >> learningCurve: lcValue [
  learningCurve := lcValue.
]

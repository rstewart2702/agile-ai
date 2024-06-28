"
This is a comparator, which uses Neurons, but it is not really itself a Neuron, is it?
The confusing bit is that NeurCOMP actually delegates its work to several other Neurons, which work in something more like the traditional manner.

NeurCOMP differs from the other Neurons in that its evaluation depends solely on a composite set of other Neurons of various kinds, like NeurNOR, NeurNOT, etc.  So, NeurCOMP itself does not need to be trained, or fiddled with, does it?
"
Class {
	#name : #NeurCOMP,
	#superclass : #Neuron,
	#instVars : [
		'notANeur',
		'notBNeur',
		'notAandBNeur',
		'notBandANeur',
		'norNeur'
	],
	#category : #NeuralNetworkRSS
}

{ #category : #evaluation }
NeurCOMP >> feed: inputs [
  | notAandB notBandA |
  notAandB := notAandBNeur feed: { notANeur feed: {inputs first. }. inputs second. }.
  notBandA := notBandANeur feed: { notBNeur feed: {inputs second.}. inputs first. }.
  ^ { notAandB . norNeur feed: { notAandB. notBandA. } . notBandA. }
]

{ #category : #initialization }
NeurCOMP >> initialize [ 
  "I think part of this boils down to whether or not the step messages belong here, or elsewhere.  This is structured to set up object-local variables for the needed neurons, instead of creating them as temporaries inside the feed: method.  So, the interface used to create these dependent Neurons is different than the one Bergel designed in the book."
  super initialize.
  notANeur := NeurNOT new step.
  notBNeur := NeurNOT new step.
  notAandBNeur := NeurAND new step.
  notBandANeur := NeurAND new step.
  norNeur := NeurNOR new step.
  ^ self
]

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
  notANeur := NeurNOT new.
  notBNeur := NeurNOT new.
  notAandBNeur := NeurAND new.
  notBandANeur := NeurAND new.
  norNeur := NeurNOR new.
  ^ self
]

# DSP_Dev

hi ! this is where i comile all my music-related code

Finished stuff :

	rubiciae - online on website - gui app findable 
	beatroot - online on website 

Currently working on : DAEW : mainvoice 

	[] simple xyz osc        | need saving in Faust  | 
	[] state variable filter | good ? > check maxrez |

	[] amp ! tanh and modulation 

	> finalyse before merge with main 
	> implement Faust dir 

	
will need modulations 
	

	 
	


wip tree:

	dsp_code 
		-> Faust			*PROCESSING*

			1> Modulate 

				16_step_trig_sequencer
				AD_envelope
				Menu_mkr
				Sequencer_Tools
				Tm4_multi 
				TM_16 bit 
				TM_4  bit 
				
			2> Gen 
				Drums/
					- hat 
					- khique 
					- kik-doesnotcomile
					- kique_v1
					- kique_v2
					- numogram_canon
					- Snare.dsp
				Acid
				Additive
				Comb
				Granular
				Karplus strons 
				Resonator 
				
			3> process
				Comb
				Doubler
				Echo
				Grnular
				Krush
				looper
				Multiband
				Multiband_sat
				neuron
				OnezeroFilter
				Resonator
				Saturation 
				Tape
				
			Boutures
				Beatroot 
				Thisle
				Rubiaecae
				 
			Interfaces
				delete 
				
			
		-> Lua	  				*INTERFACE*


			Compile project		[ ok    ]
			Daew				[ wip   ]
			Rubiaceae			[ unrel ]
			UI					[ ok    ]
			
		-> Pd					*SHARE*
		
			pure data garden to test dsp [ clean to garden ] 
			
		-> Rnbo 				*ABL*
			kique.rnbo 
			hirnbo.nextpat 

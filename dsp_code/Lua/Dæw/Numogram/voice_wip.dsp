vv
import("stdfaust.lib");
// WIP drum voice with main architecture  
//useful functions 


stof(s) = 20*2^(10*s); // better MTOF!!

faxb(in,a,b) = (in*a)+b;

trigtogate(t,time) = out
with{
	down(t) = ((-1)*t@(t*ma.SR));
	sig = down(t)+t; 
	out = _~+(sig);
};

//============== modulation 

ad_c(ac,dc,gate,legato,at,dt) = envout
with{
	envout = en.adsr_bias(at,dt,sl,rt,b_att,b_dec,b_rel,legato,gatet) // :connect:
	with{
		ht = 0; 
		sl = 0;
		rt = 0;
		final = 0;
		b_rel = 0.5;
		gate = trgtogate(d,t);
	};
};

ad_tc = out // determin gate time with seq ?
with{
	legato = 1; 
	gate = trgtogate(t,a);
	decayt = b*ma.SR;
	attackt = a*ma.SR;

	out = ad_c(ac,dc,gate,legato,attackt,decayt);
};

//======================================================= useful function bits 
 notefreq = c1 : stof ;

oscmodes(F,x,y,z,M) = hgroup("osc",out)
with{
   chout = (
           VCO1(F,x,y,z), // add xyz
           VCO2(F,x,y,z)
          );
   nchnl = chnlout : ba.count;
   out = chout : ba.selectn(nchnl(chout),int(M*nchnl)) ;//?

 VCO1(f) = os.triangle(z*f)*x+y : aa.tanh ; // placeholder
 VCO2(f) = os.ossin(z*f)*x+y : aa.tanh ; 	// placeholder     

}; // mode x y z to edit oscillators 
        (os.)triangleN : axb : fold 


/*    teat edit and make work 
                        Dream osc 
                        Osc(f,Trig,Type,x,y,z,)

                        25 modes :

                        Rich 		|| sawV =  sqr  =  width
                        East 		|| StoT =  fold =  symetry/curve
                        Shpr		||
                        Anal		||
                        Osub		||
                        Wtbl		|| 8x8 banks 
                        Grwv		|| granulize waves 
                                    // sync 5ths 
                        Nbit 		||

                        Lnfm		||
                        Exfm		||

                        Chrd		|| Qbit one for inspo 

                        Adtv     	|| nsin = sprd = start
                        Swrm		|| Swarm osc 
                        Harm    	|| 24 harm
                        Modl       	|| resonator > Rings green 

                        Swrm 		||
                        Dtun		||
                        Noiz		|| Mtal = white =  metal tun 
                        Mtal		||
                        Txtr		|| crackle/rain 

                        Kar+ 		|| rings red 

                        / drum engines  type + xy/drm !
                        Khiq		||
                        Snar		||
                        Hatz		||

                        Spxn		// define sampler based logic { grain,loop,splr }

                        Engine   | Description
                        ---------|-----------------------------------------------
                        SID      | Émulation C64 SID 6581/8580
                                | 3 oscillateurs carrés/saw/pulse/tri/noise
                                | Filtre SID (LP/BP/HP 12dB, résonance)
                                | PWM, ring mod, sync, 3 enveloppes AD
                                | → Le plus détaillé des 6 engines

                        FM+      | Synthèse FM modulaire (jusquà 6 opérateurs)
                                | Algortihmes libres (routage manuel)
                                | Ratios, feedback, loop denveloppe
                                | → Plus flexible que du 2-op, moins que DX7

                        WOOF     | Synthèse basse modelée
                                | Waveform saturée + filtre enveloppe
                                | Drive intégré, pitch/amplitude env rapide

                        VAP      | Virtual Analog Polysynth
                                | Oscillateur VA (saw/pulse avec PWM)
                                | Filtre 24dB ladder + 12dB SVF
                                | Drive, chorus intégré, détune
                                | → Le plus "classique" des 6

                        SWP      | Sweep — onde unique qui sweep
                                | Waveform glissante continue (sin → tri → saw → sqr → noise)
                                | Filtre résonant + enveloppe

                        DIGIPro  | Digital Waveshaper
                                | Table onde + waveshaper non-linéaire
                                | Saturation, bitcrush, distorsion intégrée
                                | Cross-modulation possible
                        FAUST :
                            SID     : 3 os.osc polyphoniques + en.adsr (simulation AD)
                                    fi.svf SID-style (12dB, résonance)
                            FM+     : FM modulaire (k opérateurs en série/parallèle)
                            WOOF    : os.osc[saturé] + enveloppe rapide
                            VAP     : os.osc VA + fi.ladder(freq, Q, drive)
                            SWP     : wi.crossfade[sin→tri→saw→sqr→noise] + filtrage
                            DIGIPro : rdtable[wavetable] + waveshaper + ef.cubicnl



*/

//================================= modal osc

filtmodes(F,q,z,M) = hgroup("filter", out)
with{
	chout = (
	        VCF1(F,q), // add xyz
	        VCF2(F,q)
	       );
	nchnl = chnlout : ba.count;
	out = chout : ba.selectn(nchnl(chout),N) ; //?

 VCF1(f,q,z) = _ : fi.svf_morph(f,q,z*2) ; // define 
 VCF2(f,q) = _ : fi.svf.lp(f,q,1) : aa.tanh ; 	// placeholder

    /*
            Dream filter

            Filt(in,f,q,var,mode);

            9 modes : 

            LMHb || var filt typ          
            comb ||	var +- comb 
            Allp || nbr of series lp 
            Biqd || plastiky
            Moug ||
            Obrm ||
            Saky ||
            Korg ||
            48bk || 

            Rzbk ||
            Fbnk || 

            T-4
            3) FILTER – Filtre 48 bandes
            - 48-band resonant filter bank
            - Modèles de filtres classiques
            - Modes de morphing
            FAUST : dm.analyzer_rev ou 48 BPF parallèles.
                    Le morphing = interpolation entre profils de fréquence.

            elektron  filter

            TYPE   | LP4 / LP2 / BP / HP / Notch / Double-Notch / LP-Notch / OFF
            TYPE   | LP / HP / BP / BR (MK2 ajoute Band Reject)
                
                FREQ   
                RESO   
                TYPE   
                ENV    
                KEYTR
 */
};

  //================================= modal filt



 
//================================== fodal flt 
 
//======================================================== v main synth | ^ voices

//
synth(f1,v1,c1,f2,v2,c2,f3,v3,c3,f4,v4,c4,tphz) = out  
with{
// parser for plex sgnal 
// f1,v1,c1,f2,v2,c2,f3,v3,c3,f4,v4,c4,tphz

// osc : notefreq,o1f,o1fam,o1mode,o1x,o1y,o1z
// filt : 
// vca  :
    parse = f1+v1+c1+f2+v2+c2+f3+v3+c3+f4+v4+c4+tphz;
    // analog_dmachine(v1,v2,v3,v4,c1,c2,c3)
    //out = hgroup("voice",generate(notefreq)); //: filter : sculpt);
    out = 1; //parse+generate(notefreq,o1f,o1fam,o1mode,o1x,o1y,o1z):filter:sclpt;     < make this !!!


    // oscmodes(F,x,y,z,M)
    // filtmodes(F,q,z,M)
    // < make VCA

    // lfo  env env 
    // vco vcf vca a
    // add modulation and matrix 
    //VCF(f,r)= fi.resonlp(f,r,1);

        o1f = hslider("freq_1[style:knob]",0,0,1,0.01);
        o1fam = hslider("freq_amount[style:knob]",0,0,1,0.01);
        o1mode = hslider("mode[style:knob]",0,0,1,0.01);
        o1x = hslider("x_1[style:knob]",0,0,1,0.01);
        o1y = hslider("y_1[style:knob]",0,0,1,0.01);
        o1z = hslider("z_1[style:knob]",0,0,1,0.01);

    generate(notefreq,o1f,o1fam,o1mode,o1x,o1y,o1z) = vgroup("[0]gen",gout)
    with{// base freq - kfm // mode - x - y - z || 

        base_f = o1f*127+notefreq*o1fam:ba.midikey2hz;
        gout = oscmodes(o1x,o1y,o1z);
       
    };
    filter= fout
    with{
        f1f = hslider("freq_2",0,0,1,0.01);
        f1q = hslider("cue_1",0,0,1,0.01)*10;   
        fout = vgroup("[1]filt",VCF(f1f,f1q));
    };
    sculpt = scout 
    with{
        a1 = hslider("amp_1",0,0,1,0.01);   
        scout = vgroup("[2]amp",VCA(a1));
    };

};

process = Plex:synth; //synth <:_,_;

Plex = zero:nine;
zero = vgroup("[0]0",out0)
    with{                                                       // Nothing comes out of the white snow

        p1 = hslider("[style:knob]p1_Bpm",0.5,0,1,0.01)*1000;
        p2 = hslider("[style:knob]p2_Run",0,0,1,1);

        M = 1; // speed multiplier

        x = ((p1/60)*M):hbargraph("freq",0,200);

        phz = os.hs_phasor(1.0,x,(1-run)):hbargraph("phasor",0,1);
        ctrig = (1-phz):ba.ba.impulsify;

        counter = ctrig : ba.impulsify : ctr%16 ;
        ctr(trig) = +(trig)~(_*(run));

        run = p2 : hbargraph("run",0,1);

        out0 = (counter+phz)*run;

        p3 = hslider("base f",0,0,1,0.01);
        p4 = hslider("scale select",0,0,1,0.01);
        scales = p3,p4;
};
nine(out0)  = tgroup("[1]9",noteout,out0) // f1,v1,c1 - f2,v2,c2 - f3,v3,c3 - f4,v4,c4 - timephasor
    with{
    cur_note = int(out0);

    tune(bf,scale_typ,fin) = fout // bf(0-1) - scale_typ(0-1) - fin(0-1)
    with{
            Bf = 20 * pow(1000, bf);
            Fin = 20 * pow(1000, fin); // fin also needs to become an actual frequency before quantizing

            // map compile-time index -> scale (pattern matching on the literal i)
            scaleAt(0)  = qu.ionian;
            scaleAt(1)  = qu.dorian;
            scaleAt(2)  = qu.phrygian;
            scaleAt(3)  = qu.lydian;
            scaleAt(4)  = qu.mixo;
            scaleAt(5)  = qu.eolian;
            scaleAt(6)  = qu.locrian;
            scaleAt(7)  = qu.pentanat;
            scaleAt(8)  = qu.kumoi;
            scaleAt(9)  = qu.natural;
            scaleAt(10) = qu.dodeca;
            scaleAt(11) = qu.dimin;
            scaleAt(12) = qu.penta;

            NSCALES = 13;

            // scale_typ (0-1) -> nearest integer index 0..12
            idx = int(scale_typ * (NSCALES-1) + 0.5);

            // compute quantized freq for every scale in parallel (cheap, all constants folded)
            outs = par(i, NSCALES, Fin : qu.quantize(Bf, scaleAt(i)));

            fout = outs : ba.selectn(NSCALES, idx);
    };

    sequencer(n,time) = triplesignal     // f v c 
    with{
        f(i) = hslider("[i] f_%2i [style:knob]",0,0,1,0.01);
        step_f = hgroup("[0]freq",par(i,16,f(i)) : ba.selectn(16,cur_note));

        v(i)= hslider("[i] v_%2i [style:knob]",0,0,1,0.01);
        step_v = hgroup("[1]vel",par(i,16,v(i)) : ba.selectn(16,cur_note));

        c(i)= hslider("[i] c_%2i [style:knob]",0,0,1,0.01);
        step_c = hgroup("[2]ctl_1",par(i,16,v(i)) : ba.selectn(16,cur_note));

        
        trig = step_v>0:ba.impulsify;
        Ff = step_f:ba.sAndH(trig);
        Fc = step_c:ba.sAndH(trig);
        
        triplesignal = vgroup("Seq %n",Ff,step_v,Fc);
    };

    noteout = par(i,4,sequencer(i,out0)); // 4 sequencers

};



// simle voice 

import("stdfaust.lib");

faxb(in,a,b) = (in*a)+b;
stof(s) = 20*2^(10*s); // better MTOF!!

trigtogate(time,t) = out
with{
	down(t) = ((-1)*t@(time*ma.SR));
	sig = down(t)+t; 
	out = _~+(sig): (1-t)*_>0.5;
};


/// 

adhsrt_tc = out // determin gate time with seq ? - MAXIMISE adtc 
with{
	legato = 1; 
	gate = trgtogate(t,a);
	decayt = b*ma.SR;
	attackt = a*ma.SR;
	out = ad_c(ac,dc,gate,legato,attackt,decayt);
};




freq  = 220;
morph = hslider("morph", 0, 0, 1, 0.01); // 0 = sine, 1 = triangle

//
s2tri(f,x)=out
with{
    nHarms = 12; // odd harmonics used to approximate the triangle          strain cpu - add detail 
    triComponent(k) = ((-1.0,(k-1)/2 : pow) / (k*k)) * os.osc(freq*k);
    harmonics = par(i, nHarms/2,(i*2+1 : _+0)) : par(i, nHarms/2, k, triComponent(k));
    out = os.osc(freq) + morph * (8.0/(ma.PI*ma.PI)) * sum(i, nHarms/2 - 1, triComponent(2*(i+1)+1));
};

a = hslider("a", 0, 0, 1, 0.01);
b = hslider("b", 0.5, 0, 1, 0.01);

osc = freq,morph : s2tri*0.2 : _,(1+a*9),(b*2)-1: faxb  : ef.wavefold(1): fi.dcblocker;
// clap clap 

freqF  = hslider("freq filter", 0, 0, 1, 0.01) : stof;
fq = hslider("rez", 0, 0, 1, 0.01);
fblend = hslider("Morph", 0.5, 0, 1, 0.01);

filter = _ : fi.svf_morph(freqF, fq*4, fblend*2);



at = hslider("at", 0, 0, 1, 0.01);
dt = hslider("dt", 0, 0, 1, 0.01);
ac = hslider("ac", 0.5, 0, 1, 0.01);
dc = hslider("dc", 0.5, 0, 1, 0.01);
legato = 1;


T = button("trig"):ba.impulsify;
voice = hgroup("voice",vgroup("[0]O",osc) : vgroup("[1]F",filter)) ;


import("stdfaust.lib");
G = T : trigtogate(at);
process = voice;

adtc(at,dt,ac,dc,trig,legato) = en.adsr_bias(At,1,1,Dt,ac,0,dc,legato,trig)
with{
    At = at*ma.SR;
    Dt = dt*ma.SR;

	attackt = a*ma.SR;
};

// fade in harmonics 3,5,7... progressively as morph increases, keep fundamental at unit gain
// state variable filter 


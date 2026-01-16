// WIP - does not glide 
// sub osc
// distort

//multigen sequencer


declare options "[midi:on][nvoices:1]";
import("stdfaust.lib");


midi_in = hgroup("[0]midi parser",i_o)
with{
    freq = hslider("freq[style:knob]",200,50,1000,0.01);
    gain = hslider("gain[style:knob]",0.5,0,1,0.01);
    gate = button("gate");

    i_o = freq,gain,gate;
};

instrument(freq,vel,gate) = hgroup("[1]Acid", out)
with{
    //oscillator
    osc_shp = vslider("Wave",0,0,1,1);
    osc = ba.if(osc_shp,os.sawtooth(freq),os.square(freq));

    //filter params
    filt_freq = vslider("cutoff",100,20,2000,.01):si.smoo;
    q = vslider("Q",1,1,10,.1);
    g = 1;

    //modulation
    decay = vslider("dec",0.3,0.1,1,0.01);
    env = en.adsr(0.01,decay,0,0,gate)*vel;
    fam = vslider("env amt",0,0,20,0.01);
    
    filt_freq_mod = filt_freq + (env*fam)*filt_freq;
    // main out 
    out = osc*env : fi.resonlp(filt_freq_mod,q,g);
};

process = midi_in : instrument;
// https://ccrma.stanford.edu/~jos/pasp/Karplus_Strong_Algorithm.html
// https://faustcloud.grame.fr/doc/libraries/index.html#physmodels.lib
import("stdfaust.lib");
string = vgroup("string",+~(de.fdelay4(maxDElL,delLength-1) : filter : *(damp)))
with{
    freq = hslider("[0]Freq",440,50,5000,1);
    damp = hslider("[1]Damp",0.99,0,1,0.01);
    maxDElL = 960 ;
    filter = _ <: _,_' :> /(2);
    delLength = ma.SR/freq;
};
impulse = hgroup("[1]Pluck",gate : ba.impulsify*gain)
with{
    gain = hslider("gain[style:knob]",1,0,1,0.01);
    gate = button("gate");
};
process = vgroup("Karplus Strong",impulse : string);

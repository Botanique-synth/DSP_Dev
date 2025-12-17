import("stdfaust.lib");

process = doubler;

doubler(l,r) = out 
with{
max_delay = hslider("[1]del",15,1,40,0.01);        //in ms 
oscilltion_f = hslider("[2]lfo f",15,1,20,0.01);     //in hz
mod_amount = hslider("[3]mod am",1,0,1,0.01);
feedback = hslider("[0]Feedback",0.75,0,1,0.01); 

lfo = os.phasor(1.0, oscilltion_f): tri : _*mod_amount;
tri(in) = ba.if(in>.5,1-in,in)*2;

duration = max_delay*100;

//
Dl = duration*lfo;
Dr = duration*(1-lfo);

dell = +~(
        de.delay(duration, Dl) 
        : *(feedback) 
        : fi.lowpass(4,10000) 
        : aa.tanh1 
        : fi.highpass(2,100)
);

delr = +~(
        de.delay(duration, Dr) 
        : *(feedback) 
        : fi.lowpass(4,10000) 
        : aa.tanh1 
        : fi.highpass(2,100)
);

out = l,r : dell,delr;

};

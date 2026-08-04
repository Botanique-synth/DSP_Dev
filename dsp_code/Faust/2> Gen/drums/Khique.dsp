import("stdfaust.lib");

khique(base,len,pitch,width,filtery,sat,trig) = out
with{

    decay_env(decay,trig) = y 
    with {
        t = 10+50000*decay;
        y = trig : ba.line(t*(1-trig));
    };

    upper = 100 * (1+base);
    lower = 50 * (1+base);

    env = decay_env(len,trig);
    f = decay_env(pitch/10,trig) : lower+(_*(upper-lower));
    osc = os.osci(f)*env;

    w = 100*width;
    ntch(w) = ef.dryWetMixer(filtery,fi.notchw(w,f)*100);

    out = osc*(1+(5*sat)) : ntch(w) : aa.tanh1<: _,_; 
};

trig = button("trig"): ba.impulsify;
len = hslider("hlen",0,0,1,0.001);
pitch = hslider("hpit",0,0,1,0.001);
base = hslider("Bf",0,0,1,0.001);
sat = hslider("sat",0,0,1,0.001);
width = hslider("filterx",0,0,1,0.001);
filtery = hslider("filtery",0,0,1,0.001);

process = khique(base,len,pitch,width,filtery,sat,trig);
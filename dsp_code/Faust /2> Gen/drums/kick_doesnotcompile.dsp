import("stdfaust.lib");

hit(base,len,pitch,sat,trig) = out
with{
    decay_env(decay,trig) = y 
    with {
        t = 1+10000*decay;
        y = trig : ba.line(t*(1-trig));
    };

    upper = 250 * (1+base);
    lower = 50 * (1+base);

    env = decay_env(len,trig);
    f = decay_env(pitch,trig) : mo.scale(0,1,lower,upper);
    osc = os.osci(f)*env;

    out = osc*(1+(5*sat)) : aa.tanh1<: _,_; 
};

trig = button("trig"): ba.impulsify;
len = hslider("hlen",0,0,1,0.001);
pitch = hslider("hpit",0,0,1,0.001);
base = hslider("Bf",0,0,1,0.001);
sat = hslider("sat",0,0,1,0.001);

process = hit(base,len,pitch,sat,trig);



import("stdfaust.lib");

Hat(f,spread,n,dec,trig) = out
with{
    env = en.are(0,dec,trig:ba.impulsify:ba.spulse(10));
    s = 1.2 + spread/9 ; 
    a = os.square(f);
    b = os.square(f*s);
    c = os.square(f*s*s);
    d = os.square(f*s*s*s);
    e = os.square(f*s*s*s*s);

    summ = env*(a+b+c+d+e)/6;
    noise = 5*env*n*no.noise/20;
    out = summ+noise : fi.highpass(8,5000+f/2);
};

f = hslider("freq", 1500,1500,2000,1) : si.smoo;
spread = hslider("spread",0,0,1,0.001);
decay = hslider("decay",0,0,1,0.001);
n = hslider("noise",0,0,1,0.001);
trig = button("trig");

process = Hat(f,spread,n,decay,trig);

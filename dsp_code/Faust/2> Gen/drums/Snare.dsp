import("stdfaust.lib");

snr(f,n,dec,trig) = out
with{
    env = en.are(0,dec, trig:ba.impulsify:ba.spulse(10));
    a = os.oscsin(f*(1+env));
    summ = env*a;
    noise = 5*env*env*n*no.noise/20;
    out = summ+noise;
};

f = hslider("freq", 200, 200,500,1) : si.smoo;
decay = hslider("decay",0,0,1,0.001);
n = hslider("noise",0,0,1,0.001);
trig = button("trig");

process = snr(f,n,decay,trig);
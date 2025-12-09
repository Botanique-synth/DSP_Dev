import("stdfaust.lib");

additive(f,spread,trig) = um
with{
    env = en.are(0.02,1,trig);
    s = 1 + spread*3 ; 
    a = os.oscp(f,0);
    b = os.oscp(f*s,1);
    c = os.oscp(f*s*s,0);
    d = os.oscp(f*s*s*s,1);
    e = os.oscp(f*s*s*s*s,0);
    g = os.oscp(f*s*s*s*s*s,1) : ba.mulaw_bitcrusher(4.0, 8) ;
    um = env*env*env*env*(a+b+c+d+e+f)/6;
};

f = hslider("freq", 1,1,800,1) : si.smoo;
spread = hslider("spread",0,0,1,0.001);
trig = button("trig");

process = additive(f,spread,trig);


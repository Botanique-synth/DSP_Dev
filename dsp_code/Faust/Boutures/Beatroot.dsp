import("stdfaust.lib");

// Instruments
additive(trig) = hgroup("[5] Addiv",um)
with{
    f = vslider("freq", 1,1,800,1) : si.smoo;
    spread = vslider("spread",0,0,1,0.001);
    env = en.are(0.02,1,trig:ba.spulse(100));
    s = 1 + spread*3 ; 
    a = os.oscp(f,0);
    b = os.oscp(f*s,1);
    c = os.oscp(f*s*s,0);
    d = os.oscp(f*s*s*s,1);
    e = os.oscp(f*s*s*s*s,0);
    g = os.oscp(f*s*s*s*s*s,1) ;
    um = env*env*env*env*(a+b+c+d+e+g)/6;
};
kique (trig) = hgroup("[2] Kick",y)
with{
    //params
    n       = vslider("f base", 0, 0, 1, 0.001);
    X       = vslider("X", 0, 0, 1, 0.001);
    alpha1  = vslider("decay", 0, 0, 1, 0.001) : si.smooth(0.5);
    famt    = vslider("famt", 0, 0, 1, 0.001);
    n_amt   = vslider("namt", 0, 0, 1, 0.001);        // max 0.2
    w       = vslider("fold", 0, 0, 1, 0.001);
    alpha2  = vslider("decay2", 0, 0, 1, 0.001) : si.smooth(0.5);
    d       = vslider("delay", 0, 0, 1, 0.001) : si.smooth(0.5);
    //engine
    A1 = alpha1 * 0.08 + 0.001;
    Env = en.dx7envelope(
                0.0001, 0.1, 0.1, A1,
                1, 1, 1, 0,
                trig);

    base_f = 40*pow(2,2*n);
    k = famt*10;
    main_f = base_f * (1+(Env*k));
    noise = no.noise : fi.highpass(2, 200)*n_amt*Env;
    osc1 = os.oscs(main_f) : ef.wavefold(w)*(1/w) ;
    main = osc1 + noise;
    amp1 = main*Env;
    hit = ma.tanh(ma.tanh(ma.tanh(amp1 * (1 + (10 * X)))));
    A2 = alpha2 * 0.8 + 0.001;
    D = ma.SR*(d * 0.08 + 0.001);
    E1 = en.dx7envelope(
                0.0001, 0.1, 0.1, A1,
                1, 1, 1, 0,
                trig);

    Sub_gate = E1 > 0 : de.delay(ma.SR*0.801,D);
    E2 = en.dx7envelope(
                A1, .001, .001, A2,
                1, 1, 1, 0,
                Sub_gate);

    osc2 = os.oscs(base_f);
    amp2 = osc2*E2;
    sub = ma.tanh(ma.tanh(ma.tanh(amp2 * (1 + (10 * X)))));
    y = hit + sub;
};
Hate(trig) = hgroup("[4] Hate",out)
with{
    fh      = vslider("freq_hat", 1500,1500,2000,1) : si.smoo;
    spreadh = vslider("spread hat",0,0,1,0.001);
    dech    = vslider("decay",0,0,1,0.001);
    nh      = vslider("noise h ",0,0,1,0.001);

    env = en.are(0,dech,trig:ba.impulsify:ba.spulse(10));
    s = 1.2 + spreadh/9 ; 
    a = os.square(fh);
    b = os.square(fh*s);
    c = os.square(fh*s*s);
    d = os.square(fh*s*s*s);
    e = os.square(fh*s*s*s*s);

    summ = env*(a+b+c+d+e)/6;
    noise = 5*env*nh*no.noise/20;
    out = summ+noise : fi.highpass(8,5000+fh/2);
};
snr(trig) = hgroup("[3] Snr",out)
with{
    f = vslider("freq", 200, 200,500,1) : si.smoo;
    dec = vslider("decay",0,0,1,0.001);
    n = vslider("noise",0,0,1,0.001);

    env = en.are(0,dec, trig:ba.impulsify:ba.spulse(10));
    a = os.oscsin(f*(1+env));
    summ = env*a;
    noise = 5*env*env*n*no.noise/20;
    out = summ+noise;
};

// Main clock
main_clock = timephasor
with{
    x = hslider("bpm",120,20,200,1)/4;
    run = 1-checkbox("Run!");
    timephasor = vgroup("[0] Main clock",os.hs_phasor(1.0,x/60,run));
};
// Sequencers
sequencers(phasor) = hgroup("[1]Sequencers",t1,t2,t3,t4,phasor)
with{
eu(tphz,i) = out_
    with {
    cnt = tphz*div_n : round; // counter from 0 to div_n -1 in tphz time 
    nbr  = div_n*active_steps/100 : round; // nombre a tester si divisible par count 
    tst = cnt+rot , nbr : ma.modulo;
    out_ = tst;

    active_steps  = hslider("[%] active steps[style:knob]", 20, 20, 110, 1):si.smoo;
    rot           = hslider("rotation[style:knob]", 0, 0, 1, 0.01):si.smoo;
    div_n         = nentry("[1]subdivisions", 4 ,1, 32, 1);
    count = tphz*div_n : round; // counter from 0 to div_n -1 in tphz time 
    number  = div_n*active_steps/100 : round; // nombre a tester si divisible par count 
    test = count+rot , number : ma.modulo;
    out = vgroup("euclidian",test);
};
    t1 = vgroup("[0]Kick_trig",eu(phasor,1):ba.impulsify);
    t2 = vgroup("[1]Snare_trig",eu(phasor,2):ba.impulsify);
    t3 = vgroup("[2]Hate_trig",eu(phasor,3):ba.impulsify);
    t4 = vgroup("[3]Additive_trig",eu(phasor,4):ba.impulsify);
};

// Player 
ins_plyr(t1,t2,t3,t4,phasor) = out
with{
    i1 = kique (t1);
    i2 = snr(t2);
    i3 = Hate(t3);
    i4 = additive(t4);
    preout = i1 +i2 + i3 + i4;

    out = ma.tanh(preout)*(1-(phasor==0)); // tanh to clip > antialias ?

};

process = tgroup("Beatroot", main_clock : sequencers : ins_plyr) <: _,_ ; 


/// rework euclidian sequencers with tm knowledge




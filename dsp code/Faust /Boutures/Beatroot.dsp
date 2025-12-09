import("stdfaust.lib");

//main clock
main_clock = timephasor
with{
    x = hslider("bpm",120,20,200,1);
    run = button("Run?"):ba.toggle;
    timephasor = vgroup("- Main clock",os.hs_phasor(1.0,x/60,run));
};
main_clock_trig = main_clock*-1;

// euclidian rythm maker 
euclid(tphz,div_n, active_steps, rot) = out
with {
    count = tphz*div_n : round; // counter from 0 to div_n -1 in tphz time 
    number  = div_n*active_steps/100 : round; // nombre a tester si divisible par count 
    test = count+rot , number : ma.modulo;
    out = vgroup("euclidian",test);
};
additive(f,spread,trig) = hgroup("bell",um)
with{
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
f = vslider("freq", 1,1,800,1) : si.smoo;
spread = vslider("spread",0,0,1,0.001);

active_steps  = hslider("[0]% active steps[style:knob]", 20, 20, 110, 1):si.smoo;
rot           = hslider("rotation[style:knob]", 0, 0, 1, 0.01):si.smoo;
div_n             = nentry("[1]subdivisions", 4 ,1, 32, 1);

n       = vslider("f base", 0, 0, 1, 0.001);
X       = vslider("X", 0, 0, 1, 0.001);
alpha1  = vslider("decay", 0, 0, 1, 0.001) : si.smooth(0.5);
famt    = vslider("famt", 0, 0, 1, 0.001);
n_amt   = vslider("namt", 0, 0, 1, 0.001);        // max 0.2
w       = vslider("fold", 0, 0, 1, 0.001);
alpha2  = vslider("decay2", 0, 0, 1, 0.001) : si.smooth(0.5);
d       = vslider("delay", 0, 0, 1, 0.001) : si.smooth(0.5);

// kique hit
kique (trig,alpha1,alpha2,n,famt,n_amt,X,w,d) = hgroup("kick",y)
with{
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

f_h      = vslider("freq_hat", 1500,1500,2000,1) : si.smoo;
spreadh = vslider("spread hat",0,0,1,0.001);
dech    = vslider("decay",0,0,1,0.001);
nh      = vslider("noise h ",0,0,1,0.001);

Hate(fh,spreadh,nh,dech,trig) = hgroup("hate",out)
with{
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

snr(f,n,dec,trig) = hgroup("snr",out)
with{
    env = en.are(0,dec, trig:ba.impulsify:ba.spulse(10));
    a = os.oscsin(f*(1+env));
    summ = env*a;
    noise = 5*env*env*n*no.noise/20;
    out = summ+noise;
};

f_s = vslider("freq", 200, 200,500,1) : si.smoo;
decay_s = vslider("decay",0,0,1,0.001);
n_s = vslider("noise",0,0,1,0.001);




all(clock_in) = out
with{

    tbell = euclid(clock_in,div_n, active_steps, rot):ba.impulsify;
    bell = additive(f,spread,tbell);

    trigkick = euclid(clock_in,div_n, active_steps, rot):ba.impulsify;
    kick = kique (trigkick,alpha1,alpha2,n,famt,n_amt,X,w,d);
    kout = vgroup("kique",kick);

    that = euclid(clock_in,div_n, active_steps, rot):ba.impulsify;
    hat = Hate(f_h,spreadh,nh,dech,that);
    hat_out = vgroup("Hat",hat);

    trig_s = euclid(clock_in,div_n, active_steps, rot):ba.impulsify;
    snr_final = vgroup("Snare",snr(f_s,n_s,decay_s,trig_s));


    preout = bell + hat_out + kout + snr_final ;
    out = ma.tanh(preout); // antialias ?
};

process = tgroup("drums",main_clock : all) <: _,_ ; // reorder processes clock > sequencers > sound engine
declare name "Kique";
declare version "2.0";

import("stdfaust.lib");

// Kique controls
// trig,  n (base f 0-1) , X ( sat ), alpha1 (click decay)
trig = ba.impulsify(button("trig"));
n = hslider("f base", 0, 0, 1, 0.001);
X = hslider("X", 0, 0, 1, 0.001);
alpha1 = hslider("decay", 0, 0, 1, 0.001) : si.smooth(0.5);
famt = hslider("famt", 0, 0, 1, 0.001);
n_amt = hslider("namt", 0, 0, 1, 0.001);        // max 0.2
w = hslider("fold", 0, 0, 1, 0.001);
alpha2 = hslider("decay2", 0, 0, 1, 0.001) : si.smooth(0.5);
d = hslider("delay", 0, 0, 1, 0.001) : si.smooth(0.5);

// kique hit
kique (trig,alpha1,alpha2,n,famt,n_amt,X,w,d) = y
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

process = kique(trig,alpha1,alpha2,n,famt,n_amt,X,w,d);

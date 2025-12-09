import("stdfaust.lib");

//main clock
main_clock = timephasor
with{
    x = hslider("bpm",120,20,200,1);
    timephasor = os.hs_phasor(1.0,x/60,0);
};

phz2trig(phz) = phz*-1:ba.impulsify;

// euclidian rythm maker 
euclid(tphz,div_n, active_steps, rot) = out
with {
    count = tphz*div_n : round; // counter from 0 to div_n -1 in tphz time 
    
    number  = div_n*active_steps/100; // nombre a tester si divisible par count 
    test = count+rot , number : ma.modulo;
    out = test : ba.impulsify;
};


active_steps  = hslider("% active steps", 0, 0, 100, 1);
rot           = hslider("rotation", 0, 0, 1, 0.01);
div_n             = nentry("subdivisions", 4 ,1, 32, 1);

// sample and hold 
sah(in, trig) = in : ba.latch(trig);

//coinflip 
coinflip(flip, bias) = (no.noise/2)+.5 < prob : ba.latch(flip);
flip = button("!");
prob = hslider("%", 0,0,1,0.01);

// automation?
autoControl = hslider("autoControl", 0.2, 0, 1, 0.01);
automat_test = autoControl : ba.automat(120, 16, 0);
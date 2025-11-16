declare name "Kique";
declare version "1.0";

en = library("envelopes.lib");
os = library("oscillators.lib");
ma = library("maths.lib");
ba = library("basics.lib");

Kique (f, trig ,vel ,delta1, delta2, Tau1, Tau2, X, fe);
with {
        //                                                                          {envelope block}  {trig, alpha1, alpha2, d, l, c1, c2}
        //                                                                          {ideal}  {trig, delta1,delta2} + rework time scaling

        //   delta timemanagement system
        alpha1 = delta1;
        alpha2 = delta2;
        //

        //
        A1 = alpha1 * 0.08 + 0.001;   //  }---> alpha one scaled to range ofm 0.001 to 0.081
        A2 = alpha2 * 0.8 + 0.001;
        c1 = 0;                       // <-- maybe add delta impact ?
        c2 = 0;
        l  = .5;
        //

        // Hit envelope
        //                                in -> {trig alpha1}

        hit_env = en.dx7envelope(
            0.001, A1, 0.1, 0.1,
            1, 0, 0, 0,
            trig
        );
        hit_shaped =
            (exp((-c1 * 10) - 5 * hit_env) - 1) /
            (exp((-c1 * 10) - 5) - 1 + 1e-12);          // <- curve function
                //                         out {hit_shaped}



        // Sub envelope
        //                                in -> {trig alpha1}

        sub_env = en.dx7envelope(
            0.001, A1, A2, 0.1,       //  }---> rise with a1 time decay in a2
            0, l, 0, 0,
            trig
        );
        sub_shaped =
            (exp((-c2 * 10) - 5 * sub_env) - 1) /
            (exp((-c2 * 10) - 5) - 1 + 1e-12);          // <- curve function
        //                                                                          outs -> {hit_shaped sub_shaped}

        //                                                                          Frequency calculator
        // inputs                       {f1,fE,hit_shaped,sub_shaped}
        f1 = f ;
        fe = fE ;
        // calc
        f1d = 30+f1*20;
        f2d = 30+f1*20;
        hd  = hit_shaped*(36*fe);
        sd  = sub_shaped*(36*fe);
        fhit = ba.pianokey2hz(f1d + hd);
        ffsub= ba.pianokey2hz(f2d + sd);
        // outpus                       {fhit,ffsub}




        //                                                                           Oscillator  I
        // ins                          {fhit trig shp }
        impulse1 = trig : ba.impulsify;
        ph1 = os.lf_sawpos_phase_reset(fhit, 0, impulse1);
        tri1 = ma.tanh((abs(ph1 - 0.5) - 0.25) * 16);
        bi1 = 2 * (tri1 - s1);
        s1 = cos(6.28 * ph1);
        osc1 = s1 * (1 - Tau1) + bi1 * Tau1;                                              // <- tone 1 : Tau for now sin to tri
        // out                          {osc1}

        //                                                                           Oscillator  II
        // ins                          {ffsub trig shp }
        impulse2 = trig : ba.impulsify;
        ph2 = os.lf_sawpos_phase_reset(ffsub, 0, impulse2);
        tri2 = ma.tanh((abs(ph2 - 0.5) - 0.25) * 16);
        bi2 = 2 * (tri2 - s2);
        s2 = cos(6.28 * ph2);
        osc2 = s2 * (1 - Tau2) + bi2 * Tau2;                                              // <- tone 1 : Tau for now sin to tri
        // out                          {osc2}

        // Mixer block                  {osc1 osc 2 hit_shaped sub_shaped}
        Hit  = hit_shaped * osc1 * 1.2;
        Body = sub_shaped * osc2;
        crude = Hit + Body;
        //                              {crude out}

        // tanh                         {in x}
        y = ma.tanh(ma.tanh(ma.tanh(crude * (1 + (10 * X)))));
};

// UI Controls
F = hslider("Base Freq", 50, 25, 100, 1);
T = 1 - ba.beat(160);
Delta1 = hslider("Tau 1", 0, 0, 1, 0.001);
Delta2 = hslider("Tau 2", 0, 0, 1, 0.001);
Tau1 = hslider("Tau 1", 0, 0, 1, 0.001);
Tau2 = hslider("Tau 2", 0, 0, 1, 0.001);
X = hslider("X", 0, 0, 1, 0.001);
fE = hslider("Freq Env", 0, 0, 1, 0.001);


// Main processing
y = Kique(F, T, Tau1, Tau2, X, fE);

process = y, y;

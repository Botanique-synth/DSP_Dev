en = library("envelopes.lib");
os = library("oscillators.lib");
ma = library("maths.lib");

// broad-tuned kique module with built in interface
Kique(p1) = y
    with{
        Crv(x, c) = y
            with{
                C = (-c*10)-5;
                y = (exp(C*x) - 1) / (exp(C) - 1 + 1e-12);
            };
        tanhh(in,amt)= y
        with{
            y= ma.tanh( ma.tanh( ma.tanh(in*(1+(10*amt)))));
        };
        Hit_e(trig, alpha1 ,curve1) = y
            with{
            A1 = alpha1*.08 + 0.001; // 0 to 1s                        (to scale 10-80 ms on ref)
            env = en.dx7envelope(
            0.001, A1, 0.1, 0.1,   // r1 r2 r3 r4
            1,    0, 0, 0,    // l1 l2 l3 l4
            trig);
            y = Crv(env,curve1);
        };
        Sub_e(trig, alpha1, alpha2, d, l, curve2) = y
            with{
            A1 = alpha1*.08 + 0.001; // 0 to 1s                             (to scale 10-80 ms on ref)
            A2 = alpha2*.8 + 0.001; // 0 to 1s                             (to scale )
            D = d*A1; // 0 to 1s                                              (to scale )
                    // l from 0 to 1


            R1 = D+0.001;
            L1 = 0;
            R2 = A1;
            L2 = l;
            R3 = A2;
            L3 = 0;

            env = en.dx7envelope(
                R1, R2, R3, 0.1,   // r1 r2 r3 r4
                L1, L2, L3, 0,    // l1 l2 l3 l4
                trig);

            y = Crv(env,curve2);
        };
        Kique_osc(f,t) = y
            with{
                    ph = os.lf_sawpos_phase_reset(f,0,0);
                    y = sin(2*3.14*ph);
            };

        Hite = Hit_e(T,alpha1,c1);
        Body = Sub_e(T,alpha1, alpha2, d, l , c2);

        core = Hite * Kique_osc(f,T) + Body * Kique_osc(F,0);
        y = tanhh(core,x);

        superhit = Hite*Hite*Hite*Hite;
        f = F*(1+superhit*F_env*4);

        T = button("trig");
        alpha1 = hslider("alpha 1",0,0,1,.001);
        T1 = hslider("alpha 1",0,0,1,.001);
        alpha2 = hslider("alpha 2",0,0,1,.001);
        T2 = hslider("alpha 1",0,0,1,.001);
        d      = hslider("D",0,0,1,.001);
        l      = hslider("L",0,0,1,.001);
        c1      = hslider("C1",0,0,1,.001);
        c2      = hslider("C2",0,0,1,.001);
        F       = hslider("f",50,25,100,1);
        F_env   = hslider("fe",0,0,1,.001);
        x       = hslider("X",0,0,1,.001);
    };
Hiplus(i) = oa,ob
with{
    a = hslider("a",0,0,1,0.01);
    b = hslider("b",0,0,1,0.01);
    c = hslider("c",0,0,1,0.01);
    d = hslider("d",0,0,1,0.01);
    e = hslider("e",0,0,1,0.01);
    f = hslider("f",0,0,1,0.01);

    ba = button("ba");

    ca = nentry("ca [CV:1]", 0, 0, 1, 0.01);
    cb = nentry("cb [CV:2]", 0, 0, 1, 0.01);
    cc = nentry("cc [CV:3]", 0, 0, 1, 0.01);
    cd = nentry("cd [CV:4]", 0, 0, 1, 0.01);
    ce = nentry("ce [CV:5]", 0, 0, 1, 0.01);
    cf = nentry("cf [CV:6]", 0, 0, 1, 0.01);
    p1(k,i)=k*i;

    oa = Kique(a);
    ob = oa;};

process=Hiplus(1);



// playground
en = library("envelopes.lib");
os = library("oscillators.lib");
ma = library("maths.lib");

Crv(x, c) = y
    with{
     C = (-c*10)-5;
     y = (exp(C*x) - 1) / (exp(C) - 1 + 1e-12); };
tanhh(in,amt)= y
        with{
            y= ma.tanh( ma.tanh( ma.tanh(in*(1+(10*amt)))));
        };
Hit_e(trig, alpha1 ,curve1) = y
            with{
            A1 = alpha1*.08 + 0.001; // 0 to 1s                        (to scale 10-80 ms on ref)
            env = en.dx7envelope(
            0.001, A1, 0.1, 0.1,   // r1 r2 r3 r4
            1,    0, 0, 0,    // l1 l2 l3 l4
            trig);
            y = Crv(env,curve1);
        };
Sub_e(trig, alpha1, alpha2, d, l, curve2) = y
            with{
            A1 = alpha1*.08 + 0.001; // 0 to 1s                             (to scale 10-80 ms on ref)
            A2 = alpha2*.8 + 0.001; // 0 to 1s                             (to scale )
            D = d*A1; // 0 to 1s                                              (to scale )
                    // l from 0 to 1


            R1 = D+0.001;
            L1 = 0;
            R2 = A1;
            L2 = l;
            R3 = A2;
            L3 = 0;

            env = en.dx7envelope(
                R1, R2, R3, 0.1,   // r1 r2 r3 r4
                L1, L2, L3, 0,    // l1 l2 l3 l4
                trig);

            y = Crv(env,curve2);
        };
Kique_osc(f,Retrig,Tone) = y
                with{
                    impulse = Retrig : ba.impulsify;
                    ph = os.lf_sawpos_phase_reset(f,0,impulse);  // [0-1 resetable]
                    amp = (ph*2)-1;                 //  ramp [-1 to 1 ]
                    tri = ma.tanh((abs(ph-.5)-.25)*16);                 //  ramp [-1 to 1 ] tri(x)=(abs(x-.5)-.25)*4

                    bi =2 * ( tri - s);
                    s =  cos(6.28*ph);

                    y = s*(1-Tone)+bi*Tone;
                    };
//
superhit = Hite*Hite*Hite*Hite;
f = F*(1+superhit*F_env*4);

        T = button("trig");
        alpha1 = hslider("alpha 1",0,0,1,.001);
        c1      = hslider("C1",0,0,1,.001);
        T1 = hslider("alpha 1",0,0,1,.001);
        alpha2 = hslider("alpha 2",0,0,1,.001);
        c2      = hslider("C2",0,0,1,.001);
        T2 = hslider("alpha 1",0,0,1,.001);
        d      = hslider("D",0,0,1,.001);
        l      = hslider("L",0,0,1,.001);
        F       = hslider("f",50,25,100,1);
        F_env   = hslider("fe",0,0,1,.001);
        x       = hslider("X",0,0,1,.001);




Hite = Hit_e(T,alpha1,c1);
Body = Sub_e(T,alpha1, alpha2, d, l , c2);
core = Hite * Kique_osc(f,T) + Body * Kique_osc(F,0);
y = tanhh(core,x);

process = y,y;


//
//
 Kique_osc(f,Retrig,x) = y
    with{
        impulse = Retrig : ba.impulsify;
        ph = os.lf_sawpos_phase_reset(f,0,impulse);  // [0-1 resetable]
        // y = shp(ph,Tone,a,b,c);
        y = su;

        ramp = (ph*2)-1;                 //  ramp [-1 to 1 ]
        tri =(abs(ph-.5)-.25)*4;                 //  ramp [-1 to 1 ] tri(x)=(abs(x-.5)-.25)*4
        s = cos(6.28*ph);

        su = ramp+tri; //??

    };

//
//
//
Kique_osc(f,Retrig,Tone) = y
                with{
                    impulse = Retrig : ba.impulsify;
                    ph = os.lf_sawpos_phase_reset(f,0,impulse);  // [0-1 resetable]
                    amp = (ph*2)-1;                 //  ramp [-1 to 1 ]
                    tri = ma.tanh((abs(ph-.5)-.25)*16);                 //  ramp [-1 to 1 ] tri(x)=(abs(x-.5)-.25)*4

                    bi =2 * ( tri - s);
                    s =  cos(6.28*ph);

                    y = s*(1-Tone)+bi*Tone;
                    };


Kique_osc(f,Retrig,Tone) = y
    with{
        impulse = Retrig : ba.impulsify;
        ph = os.lf_sawpos_phase_reset(f,0,impulse);  // [0-1 resetable]
        amp = (ph*2)-1;                 //  ramp [-1 to 1 ]
        tri = ma.tanh((abs(ph-.5)-.25)*16);                 //  ramp [-1 to 1 ] tri(x)=(abs(x-.5)-.25)*4

        bi =2 * ( tri - s);

        s =  cos(6.28*ph);

        y = s*(1-Tone)+bi*Tone;
    };
///



/// tone playground


en = library("envelopes.lib");
os = library("oscillators.lib");
ma = library("maths.lib");

Crv(x, c) = y
    with{
     C = (-c*10)-5;
     y = (exp(C*x) - 1) / (exp(C) - 1 + 1e-12); };
tanhh(in,amt)= y
        with{
            y= ma.tanh( ma.tanh( ma.tanh(in*(1+(10*amt)))));
        };
Hit_e(trig, alpha1 ,curve1) = y
            with{
            A1 = alpha1*.08 + 0.001; // 0 to 1s                        (to scale 10-80 ms on ref)
            env = en.dx7envelope(
            0.001, A1, 0.1, 0.1,   // r1 r2 r3 r4
            1,    0, 0, 0,    // l1 l2 l3 l4
            trig);
            y = Crv(env,curve1);
        };
Sub_e(trig, alpha1, alpha2, d, l, curve2) = y
            with{
            A1 = alpha1*.08 + 0.001; // 0 to 1s                             (to scale 10-80 ms on ref)
            A2 = alpha2*.8 + 0.001; // 0 to 1s                             (to scale )
            D = d*A1; // 0 to 1s                                              (to scale )
                    // l from 0 to 1


            R1 = D+0.001;
            L1 = 0;
            R2 = A1;
            L2 = l;
            R3 = A2;
            L3 = 0;

            env = en.dx7envelope(
                R1, R2, R3, 0.1,   // r1 r2 r3 r4
                L1, L2, L3, 0,    // l1 l2 l3 l4
                trig);

            y = Crv(env,curve2);
        };
Kique_osc(f,Retrig,Tone) = y
                with{
                    impulse = Retrig : ba.impulsify;
                    ph = os.lf_sawpos_phase_reset(f,0,impulse);  // [0-1 resetable]
                    amp = (ph*2)-1;                 //  ramp [-1 to 1 ]
                    tri = ma.tanh((abs(ph-.5)-.25)*16);                 //  ramp [-1 to 1 ] tri(x)=(abs(x-.5)-.25)*4

                    bi =2 * ( tri - s);
                    s =  cos(6.28*ph);

                    y = s*(1-Tone)+bi*Tone;
                    };
//
superhit = Hite*Hite*Hite*Hite;
f = F*(1+superhit*F_env*4);

        T = button("trig");
        alpha1 = hslider("alpha 1",0,0,1,.001);
        c1      = hslider("C1",0,0,1,.001);
        T1 = hslider("alpha 1",0,0,1,.001);
        alpha2 = hslider("alpha 2",0,0,1,.001);
        c2      = hslider("C2",0,0,1,.001);
        T2 = hslider("alpha 1",0,0,1,.001);
        d      = hslider("D",0,0,1,.001);
        l      = hslider("L",0,0,1,.001);
        F       = hslider("f",50,25,100,1);
        F_env   = hslider("fe",0,0,1,.001);
        x       = hslider("X",0,0,1,.001);




Hite = Hit_e(T,alpha1,c1);
Body = Sub_e(T,alpha1, alpha2, d, l , c2);
core = Hite * Kique_osc(f,T,T1) + Body * Kique_osc(F,T,T2);
y = tanhh(core,x);

process = y,y;

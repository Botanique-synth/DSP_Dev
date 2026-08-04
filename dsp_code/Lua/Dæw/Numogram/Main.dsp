/'
19x42
┌───────────────────────────────────────────────────────────────────────────┐
│ ┌────────────────────────────┐                                            │
│ │ NUMOGRAM__________________ │┌─{10[─┐      ┌─────]15}───────►─────────┐  │
│ │ _________DECIMAL LABYRINTH ││ ┌────┼┐     │                          │  │
│ └────────────────────────────┘│ │  4  >*┌───┼─┐        ┌─────────┐     │  │
│               ┌─◄─{36[──┐     ▼ └──┬──┘.<  5  │        │ ┌────┐  ▼     │  │
│               │         ▲     │    │....└┬──▲─┘        │ │   ┌▼──┴─┐   │  │
│  ┌]0}-┐       ▼{45[┐    │     │ ┌──┴─────┘  │          │ │ ┌─┤  3 ─┼]6}┤  │
│  ▲  ┌─┴───┐ ┌─┴───┐▲ ┌──┼──┐ ┌┴─▼──┐        │          │ │ │.└──v──┘   │  │
│  └──┼  0  >*<  9  ┼┘ │  8  >*<  1  ┼─]1}┐   └─┐        │ └─┤....*      │  │
│     └──┬──┘.└┬───▲┘  └──┬──┘.└─┬──┬┘    │     │        │   │.┌──^──┐   │  │
│        │.....│   │      │......│  ├─◄───┘     │        │   └─┤  6  ├◄──┘  │
│        └───┬─┘   │      └───┬──┘  │        ┌──┴──┐ ┌]3}┘┐    └─┼───┘      │
│            └─────┘          │     └{28[─◄┐ │...┌─┴─┼─┐  └─{21[─┘          │
│                             │          ┌─┼─┴─┐.<  2  │                    │
│                             └──────────►  7  >*└─────┘                    │
│                                        └─────┘                            │
│      └────────────┘   └──────────────────────────────┘   └────────────┘   │
│          Plex                   Time-Circuit                  Warp        │
└───────────────────────────────────────────────────────────────────────────┘
'/

import("stdfaust.lib");
process = Plex <: Timecircuit : Warp;


Timecircuit = (eight,synth_fx,synth_fx,synth_fx); // placeholders
eight =  vgroup("[4]8",ins)
with{
    ins(f1,v1,c1,f2,v2,c2,f3,v3,c3,f4,v4,c4,tphz) = out
    with{
            t1 = v1>0 : ba.impulsify;
            t2 = v2>0 : ba.impulsify;
            t3 = v3>0 : ba.impulsify;
            t4 = v4>0 : ba.impulsify;

        i1 = khique (t1);
        i2 = snr(t2);
        i3 = Hate(t3);
        i4 = additive(t4);
        preout = i1 +i2 + i3 + i4;

        out = ma.tanh(preout)*(1-(tphz==0))<:_,_; // tanh to clip > antialias ?

    };
    // Drum Instruments
        additive(trig) = hgroup("[5] Addiv",um)
        with{

            f = vslider("freq[style:knob]", 1,1,800,1) : si.smoo;
            spread = vslider("spread[style:knob]",0,0,1,0.001);
            
            dec = (vslider("dec[style:knob]",0.5,0,1,0.01)+1/2)*8;

            env = en.are(0.02,dec,trig:ba.spulse(100));

            s = 1 + spread*3; 

            a = os.oscp(f,-dec);
            b = os.oscp(f*s,dec);
            c = os.oscp(f*s*s,-dec);
            d = os.oscp(f*s*s*s,dec);
            e = os.oscp(f*s*s*s*s,-dec);
            g = os.oscp(f*s*s*s*s*s,dec) ;

            um = env*env*env*env*(a+b+c+d+e+g)/6;

        };
        Hate(trig) = hgroup("[4] Hate",out)
        with{
            fh      = vslider("freq_hat[style:knob]", 1500,1500,2000,1) : si.smoo;
            spreadh = vslider("spread hat[style:knob]",0,0,1,0.001);
            dech    = vslider("decay[style:knob]",0,0,1,0.001);
            nh      = vslider("noise h[style:knob]",0,0,1,0.001);

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

            f = hslider("freq[style:knob]", 200, 200,500,1) : si.smoo;
            dec = hslider("decay[style:knob]",0,0,1,0.001);
            n = hslider("noise[style:knob]",0,0,1,0.001);


            env = en.are(0,dec, trig:ba.impulsify:ba.spulse(10));
            a = os.oscsin(f*(1+env));
            summ = env*a;
            noise = 5*env*env*n*no.noise/20;
            out = summ+noise ;
        };
        khique(trig) = hgroup("[2] Khique",out)
        with{

            len = hslider("hlen [style:knob]",0.5,0,1,0.001);
            pitch = hslider("hpit[style:knob]",0,0,1,0.001);
            base = hslider("Bf[style:knob]",0,0,1,0.001);
            sat = hslider("sat[style:knob]",0,0,1,0.001);

            mod = hslider("mod[style:knob]",0,0,1,0.001);

            decay_env(decay,trig) = y 
            with {
                t = 10+50000*decay;
                y = trig : ba.line(t*(1-trig));
            };

            upper = 200 * (1+base);
            lower = 50 * (1+base);

            env = decay_env(len,trig);
            f = decay_env(pitch/10,trig) : lower+(_*(upper-lower));
             
            osc = os.CZhalfSine(os.sawNp(1,f/2,trig*2*ma.PI), mod)*env;

            out = osc*(1+(5*(sat))-env/2) : aa.tanh1; 
        };
};
synth_fx(f1,v1,c1,f2,v2,c2,f3,v3,c3,f4,v4,c4,tphz) = out
with{
    oui = hslider("j",0,0,1,0.01);
    out = machine(v1,v2,v3,v4,c1,c2,c3):fx(tphz);
    machine(v1,v2,v3,v4,c1,c2,c3) = oui,oui;
    fx(tphz)= _,_;
};

Warp = hgroup("[5]1",_,_,!,!,!,!,!,!:fourstereomixer)
with{ 
   in1 = _*0.2,_*0.2 ;
   in2 = 0,0 ;
   in3 = 0,0 ;
   in4 = 0,0 ;

    fourstereomixer = vgroup("Mixer",(hgroup("in1",in1),hgroup("in2",in2),hgroup("in3",in3),hgroup("in4",in4))
            : vgroup(",",vgroup("",(mix:rep)~hgroup("[3]",(del,rev))))
            : !,!,!,!,_,_)
    with{

        l1 = vslider("la[style:knob]",0,0,1,0.01);
        l2 = vslider("lb[style:knob]",0,0,1,0.01);
        l3 = vslider("lc[style:knob]",0,0,1,0.01);
        l4 = vslider("ld[style:knob]",0,0,1,0.01);
        l5 = vslider("le[style:knob]",0,0,1,0.01);
        l6 = vslider("lf[style:knob]",0,0,1,0.01);

        h1 = vslider("ha[style:knob]",0,0,1,0.01);
        h2 = vslider("hb[style:knob]",0,0,1,0.01);
        h3 = vslider("hc[style:knob]",0,0,1,0.01);
        h4 = vslider("hd[style:knob]",0,0,1,0.01);
        h5 = vslider("he[style:knob]",0,0,1,0.01);
        h6 = vslider("hf[style:knob]",0,0,1,0.01);

            del=hgroup("del",echo)
            with{
                duration = hslider("[0]Duration[style:knob]",500,1,1000,1)*0.001:si.smooth(.999);
                feedback = hslider("[1]Feedback[style:knob]",0.75,0,1,0.01);

                Dl = duration*ma.SR;
                Dr = duration*ma.SR*1.5:si.smooth(.9);
                max_del = 15*ma.SR;

                wow = 1 + os.sinwaveform(600000)*os.sinwaveform(700201):si.smooth(.99); 
                dfactor = hslider("disp [style:knob]",0.5,0,1,0.01);
                disp(i) = wa.allpass2(i*100+30*wow*i%2000,1+60*dfactor,0) : wa.allpass2(i*100-70*wow*i%2000,1+50*dfactor,0);
                disperse = seq(i,16, disp(i));

                outl = +~(
                    de.delay(max_del, Dl-1) 
                    : *(feedback) 
                    : fi.lowpass(4,10000) 
                    : de.delay(400, 3000*wow) 
                    : disperse 
                    : aa.tanh1 
                    : fi.highpass(2,100)
                );

                outr = +~(
                    de.delay(max_del, Dr-1) 
                    : *(feedback) 
                    : fi.lowpass(4,10000) 
                    : de.delay(400, 1500*wow) 
                    : disperse 
                    : aa.tanh1 
                    : fi.highpass(2,100)
                );

                dwmix = vslider("wet", 0.5,0,1,0.01);
                fx = outl,outr;
                echo = _,_ : ef.dryWetMixer(dwmix,fx);
            };


        rev=hgroup("rev",rev)
        with{
            fb1 = hslider("fb1[style:knob]",0.5,0,1,0.01);
            fb2 = hslider("fb2[style:knob]",0.5,0,1,0.01);
            damp = hslider("dmp[style:knob]",0.5,0,1,0.01);
            spread = hslider("spread[style:knob]",0.5,0,1,0.01)*ma.SR;
            rev = re.stereo_freeverb(fb1, fb2, damp, spread);
        };

        eqchl(l,h,lp,hp,blf,blv,d,o) = strip
        with{
            
            L = (l-0.5)*12;
            H = (h-0.5)*12;

            Lp = 20*2^(10*lp);
            Hp = 20*2^(10*hp);
            
            Blf = 20*2^(10*blf);
            Blv = (blv-0.5)*6;


            strip = preamp:eq;

            eq = hgroup("[1]eq",_,_:(shelves:passes:bell));

            passes  = vgroup("[2]passes",_,_:(fi.resonlp(Lp,1,1) : fi.resonhp(Hp,1,1)),(fi.resonlp(Lp,1,1) : fi.resonhp(Hp,1,1)));        // custom rez ?

            bell = vgroup("bl",_,_:fi.peak_eq(Blv,Blf,200),fi.peak_eq(Blv,Blf,200));                                // f v bandwidth { good 0-1>freq,a to db, bw(x) ?
            shelves = vgroup("[1]shelf",_,_:(fi.low_shelf( L, 500 ) : fi.high_shelf(H, 1500)),(fi.low_shelf( L, 500 ) : fi.high_shelf(H, 1500)));

            preamp = hgroup("[0]pre",_,_:(ef.cubicnl_nodc(d,o): fi.dcblocker),(ef.cubicnl_nodc(d,o): fi.dcblocker));
        };                                                   

        rep(c1r,c1l,c2r,c2l,c3r,c3l,c4r,c4l,c5r,c5l,c6r,c6l) = vgroup("_[0]",hgroup("[1]del",delb), hgroup("[2]rev",revb), hgroup("[3]vol",mout))
        with{   
            v1 = vslider("va",0,0,1,0.01);
            v2 = vslider("vb",0,0,1,0.01);
            v3 = vslider("vc",0,0,1,0.01);
            v4 = vslider("vd",0,0,1,0.01);
            v5 = vslider("ve",0,0,1,0.01);
            v6 = vslider("vf",0,0,1,0.01);

            sa1 = vslider("sa1[style:knob]",0,0,1,0.01);
            sa2 = vslider("sa2[style:knob]",0,0,1,0.01);
            sa3 = vslider("sa3[style:knob]",0,0,1,0.01);
            sa4 = vslider("sa4[style:knob]",0,0,1,0.01);
            sa5 = vslider("sa5[style:knob]",0,0,1,0.01);
            sa6 = vslider("sa6[style:knob]",0,0,1,0.01);

            sb1 = vslider("sb1[style:knob]",0,0,1,0.01);
            sb2 = vslider("sb2[style:knob]",0,0,1,0.01);
            sb3 = vslider("sb3[style:knob]",0,0,1,0.01);
            sb4 = vslider("sb4[style:knob]",0,0,1,0.01);
            sb5 = vslider("sb5[style:knob]",0,0,1,0.01);
            sb6 = vslider("sb6[style:knob]",0,0,1,0.01);

            // mixing v1,v2,v3,v4,v5,v6,sa1,sa2,sa3,sa4,sa5,sa6,sb1,sb2,sb3,sb4,sb5,sb6
            del1L = c1l*sa1;
            del1R = c1r*sa1;
            rev1L = c1l*sb1;
            rev1R = c1r*sb1;
            mout1L = c1l*v1;
            mout1R = c1r*v1;

            del2L = c2l*sa2;
            del2R = c2r*sa2;
            rev2L = c2l*sb2;
            rev2R = c2r*sb2;
            mout2L = c2l*v2;
            mout2R = c2r*v2;

            del3L = c3l*sa3;
            del3R = c3r*sa3;
            rev3L = c3l*sb3;
            rev3R = c3r*sb3;
            mout3L = c3l*v3;
            mout3R = c3r*v3;

            del4L = c4l*sa4;
            del4R = c4r*sa4;
            rev4L = c4l*sb4;
            rev4R = c4r*sb4;
            mout4L = c4l*v4;
            mout4R = c4r*v4;

            del5L = c5l*sa5;
            del5R = c5r*sa5;
            rev5L = c5l*sb5;
            rev5R = c5r*sb5;
            mout5L = c5l*v5;
            mout5R = c5r*v5;

            del6L = c6l*sa6;
            del6R = c6r*sa6;
            rev6L = c6l*sb6;
            rev6R = c6r*sb6;
            mout6L = c6l*v6;
            mout6R = c6r*v6;

            delb = del1L+del2L+del3L+del4L+del5L+del6L, del1R+del2R+del3R+del4R+del5R+del6R;
            revb = rev1L+rev2L+rev3L+rev4L+rev5L+rev6L, rev1R+rev2R+rev3R+rev4R+rev5R+rev6R;
            mout = mout1L+mout2L+mout3L+mout4L+mout5L+mout6L, mout1R+mout2R+mout3R+mout4R+mout5R+mout6R;

        }; 

        mix = hgroup("[0]chnlout",
            vgroup("c1 - rev",eqchl(ls1,hs1,lp1,hp1,bf1,bv1,d1,o1)),
            vgroup("c2 - del",eqchl(ls2,hs2,lp2,hp2,bf2,bv2,d2,o2)),
            vgroup("c3 - in 1",eqchl(ls3,hs3,lp3,hp3,bf3,bv3,d3,o3)),
            vgroup("c4 - in 2",eqchl(ls4,hs4,lp4,hp4,bf4,bv4,d4,o4)),
            vgroup("c5 - in 3",eqchl(ls5,hs5,lp5,hp5,bf5,bv5,d5,o5)),
            vgroup("c6 - in 4",eqchl(ls6,hs6,lp6,hp6,bf6,bv6,d6,o6)));

        // eq channel values 

        ls1 = hslider("1l [style:knob]",0.5,0,1,0.01);
        hs1 = hslider("1h [style:knob]",0.5,0,1,0.01);
        lp1 = hslider("1lp [style:knob]",0.5,0,1,0.01);
        hp1 = hslider("1hp [style:knob]",0.5,0,1,0.01);
        bf1 = hslider("1blf [style:knob]",0.5,0,1,0.01);
        bv1 = hslider("1blv [style:knob]",0.5,0,1,0.01);
        d1   =   hslider("1d[style:knob]",0,0,1,0.01)     :si.smoo;
        o1  =   hslider("1o[style:knob]",0,-1,1,0.1)   :si.smoo;

        ls2 = hslider("2l [style:knob]",0.5,0,1,0.01);
        hs2 = hslider("2h [style:knob]",0.5,0,1,0.01);
        lp2 = hslider("2lp [style:knob]",0.5,0,1,0.01);
        hp2 = hslider("2hp [style:knob]",0.5,0,1,0.01);
        bf2 = hslider("2blf [style:knob]",0.5,0,1,0.01);
        bv2 = hslider("2blv [style:knob]",0.5,0,1,0.01);
        d2   =   hslider("2d[style:knob]",0,0,1,0.01)     :si.smoo;
        o2  =   hslider("2o[style:knob]",0,-1,1,0.1)   :si.smoo;

        ls3 = hslider("3l [style:knob]",0.5,0,1,0.01);
        hs3 = hslider("3h [style:knob]",0.5,0,1,0.01);
        lp3 = hslider("3lp [style:knob]",0.5,0,1,0.01);
        hp3 = hslider("3hp [style:knob]",0.5,0,1,0.01);
        bf3 = hslider("3blf [style:knob]",0.5,0,1,0.01);
        bv3 = hslider("3blv [style:knob]",0.5,0,1,0.01);
        d3   =   hslider("3d[style:knob]",0,0,1,0.01)     :si.smoo;
        o3  =   hslider("3o[style:knob]",0,-1,1,0.1)   :si.smoo;

        ls4 = hslider("4l [style:knob]",0.5,0,1,0.01);
        hs4 = hslider("4h [style:knob]",0.5,0,1,0.01);
        lp4 = hslider("4lp [style:knob]",0.5,0,1,0.01);
        hp4 = hslider("4hp [style:knob]",0.5,0,1,0.01);
        bf4 = hslider("4blf [style:knob]",0.5,0,1,0.01);
        bv4 = hslider("4blv [style:knob]",0.5,0,1,0.01);
        d4   =   hslider("4d[style:knob]",0,0,1,0.01)     :si.smoo;
        o4  =   hslider("4o[style:knob]",0,-1,1,0.1)   :si.smoo;

        ls5 = hslider("5l [style:knob]",0.5,0,1,0.01);
        hs5 = hslider("5h [style:knob]",0.5,0,1,0.01);
        lp5 = hslider("5lp [style:knob]",0.5,0,1,0.01);
        hp5 = hslider("5hp [style:knob]",0.5,0,1,0.01);
        bf5 = hslider("5blf [style:knob]",0.5,0,1,0.01);
        bv5 = hslider("5blv [style:knob]",0.5,0,1,0.01);
        d5   =   hslider("5d[style:knob]",0,0,1,0.01)     :si.smoo;
        o5  =   hslider("5o[style:knob]",0,-1,1,0.1)   :si.smoo;

        ls6 = hslider("6l [style:knob]",0.5,0,1,0.01);
        hs6 = hslider("6h [style:knob]",0.5,0,1,0.01);
        lp6 = hslider("6lp [style:knob]",0.5,0,1,0.01);
        hp6 = hslider("6hp [style:knob]",0.5,0,1,0.01);
        bf6 = hslider("6blf [style:knob]",0.5,0,1,0.01);
        bv6 = hslider("6blv [style:knob]",0.5,0,1,0.01);
        d6   =   hslider("6d[style:knob]",0,0,1,0.01)     :si.smoo;
        o6  =   hslider("6o[style:knob]",0,-1,1,0.1)   :si.smoo;
        
        
    };
    
};

Plex = zero:nine;
zero = vgroup("[0]0",out0)
    with{                                                       // Nothing comes out of the white snow

        p1 = hslider("[style:knob]p1_Bpm",0.5,0,1,0.01)*1000;
        p2 = hslider("[style:knob]p2_Run",0,0,1,1);

        M = 1; // speed multiplier

        x = ((p1/60)*M):hbargraph("freq",0,200);

        phz = os.hs_phasor(1.0,x,(1-run)):hbargraph("phasor",0,1);
        ctrig = (1-phz):ba.ba.impulsify;

        counter = ctrig : ba.impulsify : ctr%16 ;
        ctr(trig) = +(trig)~(_*(run));

        run = p2 : hbargraph("run",0,1);

        out0 = (counter+phz)*run;

        p3 = hslider("base f",0,0,1,0.01);
        p4 = hslider("scale select",0,0,1,0.01);
        scales = p3,p4;
};
nine(out0)  = vgroup("[1]9",noteout,out0) // f1,v1,c1 - f2,v2,c2 - f3,v3,c3 - f4,v4,c4 - timephasor
    with{
    cur_note = int(out0);

    tune(bf,scale_typ,fin) = fout // bf(0-1) - scale_typ(0-1) - fin(0-1)
    with{
            Bf = 20 * pow(1000, bf);
            Fin = 20 * pow(1000, fin); // fin also needs to become an actual frequency before quantizing

            // map compile-time index -> scale (pattern matching on the literal i)
            scaleAt(0)  = qu.ionian;
            scaleAt(1)  = qu.dorian;
            scaleAt(2)  = qu.phrygian;
            scaleAt(3)  = qu.lydian;
            scaleAt(4)  = qu.mixo;
            scaleAt(5)  = qu.eolian;
            scaleAt(6)  = qu.locrian;
            scaleAt(7)  = qu.pentanat;
            scaleAt(8)  = qu.kumoi;
            scaleAt(9)  = qu.natural;
            scaleAt(10) = qu.dodeca;
            scaleAt(11) = qu.dimin;
            scaleAt(12) = qu.penta;

            NSCALES = 13;

            // scale_typ (0-1) -> nearest integer index 0..12
            idx = int(scale_typ * (NSCALES-1) + 0.5);

            // compute quantized freq for every scale in parallel (cheap, all constants folded)
            outs = par(i, NSCALES, Fin : qu.quantize(Bf, scaleAt(i)));

            fout = outs : ba.selectn(NSCALES, idx);
    };

    sequencer(n,time) = triplesignal     // f v c 
    with{
        f(i) = hslider("[i] f_%2i [style:knob]",0,0,1,0.01);
        step_f = hgroup("[0]freq",par(i,16,f(i)) : ba.selectn(16,cur_note));

        v(i)= hslider("[i] v_%2i [style:knob]",0,0,1,0.01);
        step_v = hgroup("[1]vel",par(i,16,v(i)) : ba.selectn(16,cur_note));

        c(i)= hslider("[i] c_%2i [style:knob]",0,0,1,0.01);
        step_c = hgroup("[2]ctl_1",par(i,16,v(i)) : ba.selectn(16,cur_note));

        
        trig = step_v>0:ba.impulsify;
        Ff = step_f:ba.sAndH(trig);
        Fc = step_c:ba.sAndH(trig);
        
        triplesignal = vgroup("Seq %n",Ff,step_v,Fc);
    };

    noteout = par(i,4,sequencer(i,out0)); // 4 sequencers

};

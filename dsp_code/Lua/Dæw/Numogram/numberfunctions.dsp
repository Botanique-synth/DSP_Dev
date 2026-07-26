import("stdfaust.lib");
process = zero:nine<:(eight,synth_fx,synth_fx,synth_fx):one;

zero = vgroup("[0]0",channel)
    with{
        // Base - accumulator


        p1 = hslider("[style:knob]p1_Bpm",0.5,0,1,0.01);
        p2 = hslider("[style:knob]p2_Run",0.5,0,1,0.01);

        channel = main_clock(p1,p2)  ;

        main_clock(bpmi,runi) = timephasor <: (_*-1:ba.spulse(1)),_
        with{
            x = ((bpmi*220)+2)/15;
            run = 1-int(runi>0.5);

            timephasor = os.hs_phasor(1.0,x,run);
        };

};

nine  = vgroup("[1]9",quadseq,tms,timephasor)
    with{
        tms = 1,1,1;

        timephasor(t) = t+hgroup("time",ma.EPSILON*(B00+B01+B02+B03+B04+B05+B06+B07+B08+B09+B10+B11+B12+B13+B14+B15))
        with{
                step = int(t*16);

                B00 = (step==0) : hbargraph("00 val[style:led]",0,1);
                B01 = (step==1) : hbargraph("01 val[style:led]",0,1);
                B02 = (step==2) : hbargraph("02 val[style:led]",0,1);
                B03 = (step==3) : hbargraph("03 val[style:led]",0,1);

                B04 = (step==4) : hbargraph("04 val[style:led]",0,1);
                B05 = (step==5) : hbargraph("05 val[style:led]",0,1);
                B06 = (step==6) : hbargraph("06 val[style:led]",0,1);
                B07 = (step==7) : hbargraph("07 val[style:led]",0,1);

                B08 = (step==8) : hbargraph("08 val[style:led]",0,1);
                B09 = (step==9) : hbargraph("09 val[style:led]",0,1);
                B10 = (step==10) : hbargraph("10 val[style:led]",0,1);
                B11 = (step==11) : hbargraph("11 val[style:led]",0,1);

                B12 = (step==12) : hbargraph("12 val[style:led]",0,1);
                B13 = (step==13) : hbargraph("13 val[style:led]",0,1);
                B14 = (step==14) : hbargraph("14 val[style:led]",0,1);
                B15 = (step==15) : hbargraph("15 val[style:led]",0,1);

        };

        quadseq(trig) = out
        with{
            out =
            hgroup("[1]#1 - kick",step_t_seq(trig)),
            hgroup("[2]#2 - Snr",step_t_seq(trig)),
            hgroup("[3]#3 - Hate",step_t_seq(trig)),
            hgroup("[4]#4 - Bell",step_t_seq(trig)); 

            cur_step(st) = hgroup("1",p1)+hgroup("2",p2)+hgroup("3",p3)+hgroup("4",p4)-1
            with{


                
                p1 = ba.if(B00==1,1,0) +
                    ba.if(B01==1,2,0) +
                    ba.if(B02==1,3,0) +
                    ba.if(B03==1,4,0);

                p2 = ba.if(B04==1,5,0) +
                    ba.if(B05==1,6,0) +
                    ba.if(B06==1,7,0) +
                    ba.if(B07==1,8,0);

                p3 = ba.if(B08==1,9,0) +
                    ba.if(B09==1,10,0) +
                    ba.if(B10==1,11,0) +
                    ba.if(B11==1,12,0);

                p4 = ba.if(B12==1,13,0) +
                    ba.if(B13==1,14,0) +
                    ba.if(B14==1,15,0) +
                    ba.if(B15==1,16,0);
            };

            step_t_seq(trig) = out
            with{
                N = vgroup("[0] Number",hslider("N[style:knob]",65535,0,65536,1)) ;//nentry("N",0,0,65536,1);65535

                //main process
                loop = out, trig, count
                    with{
                        count = (ba.counter(trig)+15) %16 : round : vgroup("[3]playhead",cur_step);
                        out = seq(i,16,gate(i,(count-1)%16)); 
                        gate( i,count,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15)= z
                            with{
                                z = ba.if(i>count,b0,b1),
                                    ba.if(i>count,b1,b2),
                                    ba.if(i>count,b2,b3),
                                    ba.if(i>count,b3,b4),
                                    ba.if(i>count,b4,b5),
                                    ba.if(i>count,b5,b6),
                                    ba.if(i>count,b6,b7),
                                    ba.if(i>count,b7,b8),
                                    ba.if(i>count,b8,b9),
                                    ba.if(i>count,b9,b10),
                                    ba.if(i>count,b10,b11),
                                    ba.if(i>count,b11,b12),
                                    ba.if(i>count,b12,b13),
                                    ba.if(i>count,b13,b14),
                                    ba.if(i>count,b14,b15),
                                    ba.if(i>count,b15,b0);
                            };

                };

                out = N:n_to_b:invert:loop:trig_mkr;

                invert(b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15) = hgroup("[4] invert",n)
                with{
                    r1= hgroup("1",
                        (
                        ba.if(checkbox("1 [style:trigger]"),b0,flip(b0)),
                        ba.if(checkbox("2"),b1,flip(b1)),
                        ba.if(checkbox("3"),b2,flip(b2)),
                        ba.if(checkbox("4"),b3,flip(b3))
                        )               );
                    r2= hgroup("2",
                        (
                        ba.if(checkbox("5"),b4,flip(b4)),
                        ba.if(checkbox("6"),b5,flip(b5)),
                        ba.if(checkbox("7"),b6,flip(b6)),
                        ba.if(checkbox("8"),b7,flip(b7))
                        )               );
                    r3= hgroup("3",
                        (
                        ba.if(checkbox("09"),b8,flip(b8)),
                        ba.if(checkbox("10"),b9,flip(b9)),
                        ba.if(checkbox("11"),b10,flip(b10)),
                        ba.if(checkbox("12"),b11,flip(b11))
                        )               );
                    r4= hgroup("4",
                        (
                        ba.if(checkbox("13"),b12,flip(b12)),
                        ba.if(checkbox("14"),b13,flip(b13)),
                        ba.if(checkbox("15"),b14,flip(b14)),
                        ba.if(checkbox("16"),b15,flip(b15))
                        )               );

                    n=r1,r2,r3,r4;
                };
                flip(b)=ba.if(b,0,1);

                trig_mkr(b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15, trig, count) = t
                with{
                    t = b15*trig:ba.impulsify;
                };
                //16 bit binary decoders
                b_to_n(b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15) = out
                    with{
                    out = b0 + b1*2 + b2*4 + b3*8 + b4*16 + b5*32 + b6*64 + b7*128 + b8*256 + b9*512 + b10*1024 + b11*2048 +  b12*4096 + b13*8192 + b14*16384 + b15*32768;
                };
                n_to_b(num) = out
                    with {
                        bit(i) = (ma.modulo(num, pow(2, i+1)) >= pow(2, i));
                        out = bit(0), bit(1), bit(2), bit(3),
                            bit(4), bit(5), bit(6), bit(7),
                            bit(8), bit(9), bit(10), bit(11),
                            bit(12), bit(13), bit(14), bit(15);
                        };
                //ui
                see16(b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15) = p
                with{
                    B0 = b0 : vbargraph("00 val[style:led]",0,1);
                    B1 = b1 : vbargraph("01 val[style:led]",0,1);
                    B2 = b2 : vbargraph("02 val[style:led]",0,1);
                    B3 = b3 : vbargraph("03 val[style:led]",0,1);

                    B4 = b4 : vbargraph("04 val[style:led]",0,1);
                    B5 = b5 : vbargraph("05 val[style:led]",0,1);
                    B6 = b6 : vbargraph("06 val[style:led]",0,1);
                    B7 = b7 : vbargraph("07 val[style:led]",0,1);

                    B8 = b8 : vbargraph("08 val[style:led]",0,1);
                    B9 = b9 : vbargraph("09 val[style:led]",0,1);
                    B10 = b10 : vbargraph("10 val[style:led]",0,1);
                    B11 = b11 : vbargraph("11 val[style:led]",0,1);

                    B12 = b12 : vbargraph("12 val[style:led]",0,1);
                    B13 = b13 : vbargraph("13 val[style:led]",0,1);
                    B14 = b14 : vbargraph("14 val[style:led]",0,1);
                    B15 = b15 : vbargraph("15 val[style:led]",0,1);

                    l1 = hgroup("1_",B0,B1,B2,B3);
                    l2 = hgroup("2_",B4,B5,B6,B7);
                    l3 = hgroup("3_",B8,B9,B10,B11);
                    l4 = hgroup("4_",B12,B13,B14,B15);
                    
                    p = vgroup("[5] seq",l1,l2,l3,l4);
                };
                see162(b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15, trig, count) = hgroup("loop out",p, trig,count)
                with{
                    B0 = b0 : vbargraph("00 val[style:led]",0,1);
                    B1 = b1 : vbargraph("01 val[style:led]",0,1);
                    B2 = b2 : vbargraph("02 val[style:led]",0,1);
                    B3 = b3 : vbargraph("03 val[style:led]",0,1);

                    B4 = b4 : vbargraph("04 val[style:led]",0,1);
                    B5 = b5 : vbargraph("05 val[style:led]",0,1);
                    B6 = b6 : vbargraph("06 val[style:led]",0,1);
                    B7 = b7 : vbargraph("07 val[style:led]",0,1);

                    B8 = b8 : vbargraph("08 val[style:led]",0,1);
                    B9 = b9 : vbargraph("09 val[style:led]",0,1);
                    B10 = b10 : vbargraph("10 val[style:led]",0,1);
                    B11 = b11 : vbargraph("11 val[style:led]",0,1);

                    B12 = b12 : vbargraph("12 val[style:led]",0,1);
                    B13 = b13 : vbargraph("13 val[style:led]",0,1);
                    B14 = b14 : vbargraph("14 val[style:led]",0,1);
                    B15 = b15 : vbargraph("15 val[style:led]",0,1);
                    
                    p = B0,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15;
                };
                cur_step(st) = hgroup("1",p1)+hgroup("2",p2)+hgroup("3",p3)+hgroup("4",p4)-1
                with{
                    step = st;


                    B00 = (step==0) ;//: hbargraph("00 val[style:led]",0,1);
                    B01 = (step==1) ;//: hbargraph("01 val[style:led]",0,1);
                    B02 = (step==2) ;//: hbargraph("02 val[style:led]",0,1);
                    B03 = (step==3) ;//: hbargraph("03 val[style:led]",0,1);

                    B04 = (step==4) ;//: hbargraph("04 val[style:led]",0,1);
                    B05 = (step==5) ;//: hbargraph("05 val[style:led]",0,1);
                    B06 = (step==6) ;//: hbargraph("06 val[style:led]",0,1);
                    B07 = (step==7) ;//: hbargraph("07 val[style:led]",0,1);

                    B08 = (step==8) ;//: hbargraph("08 val[style:led]",0,1);
                    B09 = (step==9) ;//: hbargraph("09 val[style:led]",0,1);
                    B10 = (step==10) ;//: hbargraph("10 val[style:led]",0,1);
                    B11 = (step==11) ;//: hbargraph("11 val[style:led]",0,1);

                    B12 = (step==12) ;//: hbargraph("12 val[style:led]",0,1);
                    B13 = (step==13) ;//: hbargraph("13 val[style:led]",0,1);
                    B14 = (step==14) ;//: hbargraph("14 val[style:led]",0,1);
                    B15 = (step==15) ;//: hbargraph("15 val[style:led]",0,1);

                    
                    p1 = ba.if(B00==1,1,0) +
                        ba.if(B01==1,2,0) +
                        ba.if(B02==1,3,0) +
                        ba.if(B03==1,4,0);

                    p2 = ba.if(B04==1,5,0) +
                        ba.if(B05==1,6,0) +
                        ba.if(B06==1,7,0) +
                        ba.if(B07==1,8,0);

                    p3 = ba.if(B08==1,9,0) +
                        ba.if(B09==1,10,0) +
                        ba.if(B10==1,11,0) +
                        ba.if(B11==1,12,0);

                    p4 = ba.if(B12==1,13,0) +
                        ba.if(B13==1,14,0) +
                        ba.if(B14==1,15,0) +
                        ba.if(B15==1,16,0);
                };
                see1(in1) = bar1
                with{
                    bar1 = in1 : hbargraph("seq[style:numerical]",-1,1);
                };
                };
            
        };
};

eight =  vgroup("[4]8",ins)
with{
    ins(t1,t2,t3,t4,tms1,tms2,tms3,phasor) = out

    with{
        i1 = khique (t1);
        i2 = snr(t2);
        i3 = Hate(t3);
        i4 = additive(t4);
        preout = i1 +i2 + i3 + i4;

        out = ma.tanh(preout)*(1-(phasor==0))<:_,_; // tanh to clip > antialias ?

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



one = hgroup("[5]1",_,_,!,!,!,!,!,!:fourstereomixer)
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

synth_fx(t1,t2,t3,t4,tms1,tms2,tms3,phasor) = out
with{
    oui = hslider("j",0,0,1,0.01);
    out = machine(t1,t2,t3,t4,tms1,tms2,tms3):fx(phasor);
    machine(t1,t2,t3,t4,tms1,tms2,tms3) = oui,oui;
    fx(phasor)= _,_;
};
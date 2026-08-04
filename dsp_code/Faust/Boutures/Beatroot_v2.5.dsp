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

    f = hslider("freq", 200, 200,500,1) : si.smoo;
    dec = hslider("decay",0,0,1,0.001);
    n = hslider("noise",0,0,1,0.001);


    env = en.are(0,dec, trig:ba.impulsify:ba.spulse(10));
    a = os.oscsin(f*(1+env));
    summ = env*a;
    noise = 5*env*env*n*no.noise/20;
    out = summ+noise <: doubler : _+_ ;


    doubler(l,r) = out 
    with{
        max_delay = hslider("[1]del",15,1,40,0.01);        //in ms 
        oscilltion_f = hslider("[2]lfo f",15,1,20,0.01);     //in hz
        mod_amount = hslider("[3]mod am",1,0,1,0.01);
        feedback = hslider("[0]Feedback",0.75,0,1,0.01); 

        lfo = os.phasor(1.0, oscilltion_f): tri : _*mod_amount;
        tri(in) = ba.if(in>.5,1-in,in)*2;

        duration = max_delay*100;

        //
        Dl = duration*lfo;
        Dr = duration*(1-lfo);

        dell = +~(
                de.delay(duration, Dl) 
                : *(feedback) 
                : fi.lowpass(4,10000) 
                : aa.tanh1 
                : fi.highpass(2,100)
        );

        delr = +~(
                de.delay(duration, Dr) 
                : *(feedback) 
                : fi.lowpass(4,10000) 
                : aa.tanh1 
                : fi.highpass(2,100)
        );

        out = l,r : dell,delr;

    };
};
khique(trig) = hgroup("[2] Khique",out)
with{

    len = hslider("hlen [style:knob]",0.5,0,1,0.001);
    pitch = hslider("hpit[style:knob]",0,0,1,0.001);
    base = hslider("Bf[style:knob]",0,0,1,0.001);
    sat = hslider("sat[style:knob]",0,0,1,0.001);
    width = hslider("filterx[style:knob]",0,0,1,0.001);
    filtery = hslider("filtery[style:knob]",0,0,1,0.001);

    decay_env(decay,trig) = y 
    with {
        t = 10+50000*decay;
        y = trig : ba.line(t*(1-trig));
    };

    upper = 100 * (1+base);
    lower = 50 * (1+base);

    env = decay_env(len,trig);
    f = decay_env(pitch/10,trig) : lower+(_*(upper-lower));
    osc = os.osci(f)*env;

    w = 100*width;
    ntch(w) = ef.dryWetMixer(filtery,fi.notchw(w,f)*100);

    out = osc*(1+(5*sat)) : ntch(w) : aa.tanh1; 
};

step_t_seq(trig) = out
with{
N = vgroup("[0] Number",vslider("N",65535,0,65535,1)) ;//nentry("N",0,0,65536,1);
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
    out = N:n_to_b:invert:see16:loop:trig_mkr;
    invert(b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15) = vgroup("[4] invert",n)
    with{
        r1= hgroup("1",
            (
            ba.if(checkbox("1"),b0,flip(b0)),
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


main_clock = timephasor
with{
    x = hslider("bpm",120,20,200,1);
    run = 1-checkbox("Run!");
    timephasor = vgroup("[1] Main clock",os.hs_phasor(1.0,x/15,run));
};
pulse = main_clock*-1:ba.spulse(1);

quadseq(pulse) = out
    with{
        out = tgroup("[2]Quad sequencer",
        hgroup("#1 - kick",step_t_seq(pulse)),
        hgroup("#2 - Snr",step_t_seq(pulse)),
        hgroup("#3 - Hate",step_t_seq(pulse)),
        hgroup("#4 - Bell",step_t_seq(pulse))
                    ); 
};

instruments(t1,t2,t3,t4,phasor) = tgroup("[0]instr",out)
with{
    i1 = khique (t1);
    i2 = snr(t2);
    i3 = Hate(t3);
    i4 = additive(t4);
    preout = i1 +i2 + i3 + i4;

    out = ma.tanh(preout)*(1-(phasor==0)); // tanh to clip > antialias ?

};

process = vgroup("Beatroot", pulse : quadseq : _,_,_,_,main_clock :instruments ) : _*.1 <: krush(1) ;

krush(in) = hgroup("lofi",main_out)
with{
    //Main process line 
    main_out = infilter : dspl : bcr : drive : outfilt;

    //code functions 
    infilter(l,r) = hgroup("[0]Filters in", l,r : lp : hp)
    with{
        lp = fi.resonlp(flp,qlp,g),fi.resonlp(flp,qlp,g);
        hp = fi.resonhp(fhp,qhp,g),fi.resonhp(fhp,qhp,g);

        flp = vslider("Lp cutoff",20000,20,20000,1);
        qlp = vslider("Lp Q",1,1,10,0.01);
        fhp = vslider("hp cutoff",2,2,20000,1);
        qhp = vslider("hp Q",1,1,10,0.01);

        g = vslider("Gain",1,1,10,0.01);
    };
    dspl(l,r) = l,r : vgroup("[1]downsample",out)
    with {
        n = vslider("amt",1,1,100,1);
        out = ba.downSample(ma.SR/n),ba.downSample(ma.SR/n);
        //stepping ??
    };
    bcr(l,r) = vgroup("[2]bcr", l,r : out)
    with{
    nbits = vslider("bitcrush",1,0.05,1,0.001)*24 : round;
    out = ba.bitcrusher(nbits),ba.bitcrusher(nbits); 
    };
    drive(l,r) = l,r : out
    with{
        sat = vslider("sat",1,0,1,0.001);
        out = aa.tanh1,aa.tanh1;
    };
    outfilt(l,r) = hgroup("[3]Filters out", l,r : lp : hp)
    with{
        lp = fi.resonlp(flp,qlp,g),fi.resonlp(flp,qlp,g);
        hp = fi.resonhp(fhp,qhp,g),fi.resonhp(fhp,qhp,g);

        flp = vslider("Lp cutoff",20000,20,20000,1);
        qlp = vslider("Lp Q",1,1,10,0.01);
        fhp = vslider("hp cutoff",2,2,20000,1);
        qhp = vslider("hp Q",1,1,10,0.01);

        g = 1;
    };
    };

import("stdfaust.lib");

step_t_seq(trig) = out
    with{
    N = vgroup("[0] Number",vslider("N",0,0,65535,1)) ;//nentry("N",0,0,65536,1);
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
    x = vslider("bpm",120,20,200,1);
    run = 1-checkbox("Run!");
    timephasor = vgroup("[0] Main clock",os.hs_phasor(1.0,x/15,run));
};
pulse = main_clock*-1:ba.spulse(1);

Drum_AD(trig,a,d, ex_f) = out
with{
    attack_time = 10 +  a*.500*ma.SR;
    decay_time = d*1.5*ma.SR;

    trg = trig <: _,_@attack_time : _+_ : _;

    env_time(counterpos)=ba.if(counterpos,attack_time,decay_time);

    count = ba.counter(trg) % 2;
    line = count : ba.line(env_time(count));
    
    ex = (ex_f-.5)*10 : round ;
    exf(in) = pow(in,ba.if(ex>1,ex,(-1/ex)));

    out = line : exf; 
}; 

trig = button("!"):ba.impulsify:abs;
a1 = hslider("attack1", 0,0,1,0.01);
d1 = hslider("decay1", 0,0,1,0.01);
ex_f1 = hslider("exponent1",0,0,1,0.01);

tm(trig,prob) = hgroup("TM",_~k)
with{
    k = ba.sAndH(trig) : n_to_b : rott : bflip(prob,trig) : b_to_n;

    //number to binary (16 bit)
        n_to_b(num) = out
        with {
        bit(i) = (ma.modulo(num, pow(2, i+1)) >= pow(2, i));
        out = bit(0), bit(1), bit(2), bit(3),
            bit(4), bit(5), bit(6), bit(7),
            bit(8), bit(9), bit(10), bit(11),
            bit(12), bit(13), bit(14), bit(15);
    };
    // Rotation 
    rott(b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15) = 
        b15,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14;

    bflip(prob,trig,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15) = bN
    with{
        cond = coinflip(trig,prob);
        F = ba.if(cond,invertbit(b0),b0);
        bN = F,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15;
    };

    coinflip(flip, prob) = (no.noise/2)+.5 < prob : ba.latch(flip);
    invertbit(in) = ba.if(in,0,1);

    //binary to number (16 bit)
    b_to_n(b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15) = out
    with{
    out = b0 + b1*2 + b2*4 + b3*8 + b4*16 + b5*32 + b6*64 + b7*128 + b8*256 + b9*512 + b10*1024 + b11*2048 +  b12*4096 + b13*8192 + b14*16384 + b15*32768;
    };

};

flip = button("!") : ba.impulsify;
prob = hslider("TM%[style:knob]", 0,0,1,0.01);

process = main_clock : hgroup("R-S",p);

p(phasor) = out
with{
    pulse = phasor*-1:ba.spulse(1);

    p = pulse;
    tg = step_t_seq(p);
    vout(tg) = os.triangle(200+200*(tm(tg,prob) / 64535) : qu.quantize(400,qu.penta));
    out = vout(tg)*Drum_AD(tg,a1,d1,ex_f1);
};

import("stdfaust.lib");
// backup functions
Drum_AD(trig,a,d, ex_f) = out
with{
    attack_time = 60 + abs(a*.500*ma.SR);
    decay_time = (d*1*ma.SR)+1;
    trg = trig <: _,_@abs(attack_time) : _+_ : _;
    env_time(counterpos)=ba.if(counterpos,attack_time,decay_time);
    count = ba.counter(trg) % 2;
    line = count : ba.line(env_time(count));
    ex = (ex_f-.5)*10 : round ;
    exf(in) = pow(in,ba.if(ex>1,ex,(-1/ex)));
    out = line : exf; 
}; 
main_clock = timephasor
with{
    run = 1-checkbox("Run!");
    timephasor = vgroup("[0] Main clock",os.hs_phasor(1.0,bpm/15/4,run));
};
pulse = main_clock*-4:_%2 :ba.spulse(1);

//.                                                                   -> work with automate
bpm = vslider("bpm",80,20,100,1);
a = vslider("[4]Exite shape[style:knob]",0.25,0,1,0.01):si.smoo; 
c = vslider("Decay",0.2,0,1,0.01):si.smoo: ba.automat(bpm,16,0.2);
f = vslider("freq", 100,10,800,1) : si.smoo; 
spread = vslider("Hsprd",0,0,1,0.001): si.smooth(.8): ba.automat(bpm,16,0);
k = vslider("oddlvl",0.5,0,1,0.001): ba.automat(bpm,16,0.2);
n = vslider("n.o.h",4,1,32,1): ba.automat(bpm,16,4);

//
rez(f,n,spread,in,N) = hgroup("rez",out)
with{
    nbr = 2*N/65535;
    testn = N%4 == 0;
    gain = 1/(3+(5*c));
    q = 10+ 80*c;
    freq = f*(1+nbr)*(1+(testn*2));
    rezfilter(in, i) = out
    with{
        s = spread*2;
        F = (freq*pow(i+1,s)%20000) : qu.quantize(220, qu.pentanat): ba.if(freq*pow(s,i) < 20000,_,20000);
        filtering(i,nbr,in) = 
                in: fi.resonbp(F, q, gain)
                  : fi.resonlp(F, q, gain)
                  : fi.resonhp(F, q, gain)
                  : ba.if(i<(n),_,0)
                  * ((i%2)*impair + ((i+1)%2)*pair);
        
        impair = ba.if(k<.5,k*2,1); 
        pair   = ba.if(k>.5,-2*k+2,1);
        out = in : filtering(i,nbr) * (1/(1+i*5)) ;
    };
    out = sum(i,32,rezfilter(in,i)); 
};
sequence = out
with {
    imp = out
    with{ 
        env = Drum_AD(pass,a/8 %200,a/2, .95);
        preout = env*no.noise;
        out = preout *.2*(1/(1+(a*3))); 
        };
    pass = coinflip_pass(pulse,trig_prob); 
    trig_prob = vslider("[1]trig %[style:knob]", 0.5,0,1,0.01);
    prob = vslider("[0]note seq[style:knob]", .9,0,1,0.01);
    out = vgroup("binary decoders",imp,tm(pass,prob));
};



// main process function 
p = sequence : rez(f,n,spread)/2 : echo;
process = hgroup("Ambient machine",p) : _,_ ;

echo = vgroup("echo", out)
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
    out = _ <: ef.dryWetMixer(dwmix,fx);
};
tm(trig,prob) = _~k
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
coinflip_pass(flip,bias) = out
with{ 
    out = pre*flip;
    pre = (no.noise/2)+.5 < bias : ba.latch(flip);
};
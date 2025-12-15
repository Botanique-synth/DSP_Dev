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

// latch
latch(in, trig) = in : ba.latch(trig);

//coinflip 
coinflip(flip, bias) = (no.noise/2)+.5 < prob : ba.latch(flip);
flip = button("!");
prob = hslider("%", 0,0,1,0.01);

// automation?
autoControl = hslider("autoControl", 0.2, 0, 1, 0.01);
automat_test = autoControl : ba.automat(120, 16, 0);


/// turing machine organs 


import("stdfaust.lib");

// gui to see binary numbers, pairs and sextuplets
see2(in1,in2) = bar1, bar2
with{
    bar1 = in1 : vbargraph("1 val[style:numerical]",-1,1);
    bar2 = in2 : vbargraph("2 prev[style:numerical]",-1,1);
};
see1(in1) = bar1
with{
    bar1 = in1 : vbargraph("1 val[style:numerical]",-1,1);
};
see16(b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15) = hgroup("binary decoder",p)
with{
    B0 = b0 : vbargraph("0 val[style:led]",0,1);
    B1 = b1 : vbargraph("1 val[style:led]",0,1);
    B2 = b2 : vbargraph("2 val[style:led]",0,1);
    B3 = b3 : vbargraph("3 val[style:led]",0,1);

    B4 = b4 : vbargraph("4 val[style:led]",0,1);
    B5 = b5 : vbargraph("5 val[style:led]",0,1);
    B6 = b6 : vbargraph("6 val[style:led]",0,1);
    B7 = b7 : vbargraph("7 val[style:led]",0,1);

    B8 = b8 : vbargraph("8 val[style:led]",0,1);
    B9 = b9 : vbargraph("9 val[style:led]",0,1);
    B10 = b10 : vbargraph("10 val[style:led]",0,1);
    B11 = b11 : vbargraph("11 val[style:led]",0,1);

    B12 = b12 : vbargraph("12 val[style:led]",0,1);
    B13 = b13 : vbargraph("13 val[style:led]",0,1);
    B14 = b14 : vbargraph("14 val[style:led]",0,1);
    B15 = b15 : vbargraph("15 val[style:led]",0,1);
    
    p = B0,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15;
};

// better sample and hold 
sah(in_signal,trig) = val , prev_val
with{
    t = ba.spulse(10,trig : ba.impulsify);
    prev_val =  val : ba.sAndH(t);
    val = in_signal : ba.sAndH(t@10);
};
trig = button("trig");

//number to binary (16 bit)
n_to_b(num) = out
with {
    bit(i) = (ma.modulo(num, pow(2, i+1)) >= pow(2, i));
    out = bit(0), bit(1), bit(2), bit(3),
          bit(4), bit(5), bit(6), bit(7),
          bit(8), bit(9), bit(10), bit(11),
          bit(12), bit(13), bit(14), bit(15);
};

//binary to number (16 bit)
b_to_n(b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15) = out
with{
  out = b0 + b1*2 + b2*4 + b3*8 + b4*16 + b5*32 + b6*64 + b7*128 + b8*256 + b9*512 + b10*1024 + b11*2048 +  b12*4096 + b13*8192 + b14*16384 + b15*32768;
  };

rott(b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15) = 
    b15,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14;


process = hslider("num",0,0,65535,1) : see1;




//// Working 16 bit turing machine !

import("stdfaust.lib");
// better sample and hold 
sah(trig) = val
with{
    t = ba.spulse(10,trig : ba.impulsify);
    prev_val =  val : ba.sAndH(t);
    val = no.noise : ba.sAndH(t@10);
};
trig = button("trig"):ba.impulsify;


//number to binary (16 bit)
n_to_b(num) = out
with {
    bit(i) = (ma.modulo(num, pow(2, i+1)) >= pow(2, i));
    out = bit(0), bit(1), bit(2), bit(3),
          bit(4), bit(5), bit(6), bit(7),
          bit(8), bit(9), bit(10), bit(11),
          bit(12), bit(13), bit(14), bit(15);
};

//binary to number (16 bit)
b_to_n(b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15) = out
with{
  out = b0 + b1*2 + b2*4 + b3*8 + b4*16 + b5*32 + b6*64 + b7*128 + b8*256 + b9*512 + b10*1024 + b11*2048 +  b12*4096 + b13*8192 + b14*16384 + b15*32768;
  };
rott(b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15) = 
    b15,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14;

coinflip(flip, prob) = (no.noise/2)+.5 < prob : ba.latch(flip);
flip = button("!");
prob = hslider("%", 0,0,1,0.01);
invertbit(in) = ba.if(in,0,1);

bflip(prob,trig,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15) = bN
with{
    cond = coinflip(trig,prob);
    F = ba.if(cond,invertbit(b0),b0);
    bN = F,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15;
};

see16(b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15) = hgroup("binary decoder",p)
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
see1(in1) = bar1
with{
    bar1 = in1 : vbargraph("1 val[style:numerical]",-1,1);
};

k = ba.sAndH(trig) : n_to_b : rott : bflip(prob,trig) : see16 : b_to_n : see1;
tm = _~k;

process = tm;
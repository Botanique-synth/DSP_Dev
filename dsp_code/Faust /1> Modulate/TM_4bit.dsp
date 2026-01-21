//// 4 bit tm 
import("stdfaust.lib");

// interface 
trig = button("trig"):ba.impulsify;
prob = hslider("% [style:knob]", 0,0,1,0.01);

// brain 
tm4(prob,trig) = hgroup("tm n",_~k)
with{
    k = ba.sAndH(trig) : n_to_b : rott : bflip(prob,trig) : Line : b_to_n ;

    //number to binary
    n_to_b(num) = out
    with {
        bit(i) = (ma.modulo(num, pow(2, i+1)) >= pow(2, i));
        out = bit(0), bit(1), bit(2), bit(3);
    };

    //rotation 
    rott(b0,b1,b2,b3) = 
    b3,b0,b1,b2;

    // bit flip 
    bflip(prob,trig,b0,b1,b2,b3) = bN
    with{
        cond = coinflip(trig,prob);
        F = ba.if(cond,invertbit(b0),b0);
        bN = F,b1,b2,b3;

        coinflip(flip, prob) = (no.noise/2)+.5 < prob : ba.latch(flip);
        invertbit(in) = ba.if(in,0,1);
    };

    // see values 
        Line(b0,b1,b2,b3) = hgroup("line",p)
    with{
        B0 = b0 : vbargraph("00 val[style:led]",0,1);
        B1 = b1 : vbargraph("01 val[style:led]",0,1);
        B2 = b2 : vbargraph("02 val[style:led]",0,1);
        B3 = b3 : vbargraph("03 val[style:led]",0,1);
        
        p = B0,B1,B2,B3;
    };

    //binary to number
    b_to_n(b0,b1,b2,b3) = out
    with{
     out = b0 + b1*2 + b2*4 + b3*8;
    };
};

process = tm4(prob,trig);
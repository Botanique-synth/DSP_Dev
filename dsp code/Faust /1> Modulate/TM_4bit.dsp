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
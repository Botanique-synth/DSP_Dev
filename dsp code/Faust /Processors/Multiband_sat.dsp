import("stdfaust.lib");
//
// (an.)amp_follower_ar
// _ : resonator(N,f) : _,_ // magnitude, phase
// (aa.)clip
// (aa.)Ratanh. Real-valued atanh().

// (aa.)hardclip2
// (aa.)parabolic2
// (aa.)hyperbolic2
// (aa.)sinarctan2     ~>ok
// (aa.)tanh2          ~>ok
// (aa.)softclipQuadratic2
multisat(in) = out
with{
    select = nentry("label",1,1,5,1);
    s1(in) = in: aa.hardclip2;
    s2(in) = in: aa.hyperbolic2;
    s3(in) = in: aa.sinarctan2;
    s4(in) = in: aa.tanh1;
    s5(in) = in: aa.softclipQuadratic2;

    out = 
    (select==1,s1(in)),(select==2,s2(in)),(select==3,s3(in)),
    (select==4,s4(in)),(select==5,s5(in)),
    in:ba.ifNc(5);
};


// Where:

//     N is the IFFT size (power of 2)
//     Input is a complex spectrum represented as interleaved real and imaginary parts: (R0, I0), (R1,I1), (R2,I2), ...
//     Output is a bank of N complex signals giving the complex signal in the time domain: (r0, i0), (r1,i1), (r2,i2), ...

// Test

// an = library("analyzers.lib");
// os = library("oscillators.lib");
// ifft_test = (an.rtocv(8, os.osc(220)) : an.fft(8)) : an.ifft(8);



multiband(in) = out
with{
    f1 = hslider("f1",100,1,500,1);
    f2 = hslider("f2",1000,500,20000,1);
    n = hslider("amt",1,1,100,0.1);
    split(in,f1,f2) = in : fi.crossover3LR4(f1,f2);

    p1(a) = vgroup("low",a*n:multisat);
    p2(b) = vgroup("mid",b*n:multisat);
    p3(c) = vgroup("hi",c*n:multisat);

    merge(x,y,z) = x + y + z;

    out = split(in,f1,f2) : p1,p2,p3 : merge;
};


process = _ : multiband <: _,_; 
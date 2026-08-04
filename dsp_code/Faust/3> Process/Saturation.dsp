import("stdfaust.lib");

multisat(gain,bias,input) = hgroup("sat",out)
with{
    in_pre = input * (1+(gain*100));
    in = in_pre + bias;

    s1(in) = in: aa.hardclip2;
    s2(in) = in: aa.hyperbolic2;
    s3(in) = in: aa.sinarctan2;
    s4(in) = in: aa.tanh1;
    s5(in) = in: aa.softclipQuadratic2;
    s6(in) = in: aa.clip(-1,1);
    s7(in) = in: aa.cubic1;
    s8(in) = in: aa.arctan2;


    out_pre = 
    (select==1,s1(in)),
    (select==2,s2(in)),
    (select==3,s3(in)),
    (select==4,s4(in)),
    (select==5,s5(in)),
    (select==6,s6(in)),
    (select==7,s7(in)),
    (select==8,s8(in)),
    in:ba.ifNc(8);

    out = out_pre: fi.dcblocker; 

    select = nentry("label",1,1,8,1);
};


gain = vslider("gain [style:knob]",0,0,1,0.001);
bias = vslider("bias [style:knob]",0,0,1,0.001);
process = multisat(gain,bias); 
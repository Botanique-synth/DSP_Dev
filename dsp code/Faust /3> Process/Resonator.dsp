import("stdfaust.lib");
// backup functions
Drum_AD(trig,a,d, ex_f) = out
with{
    attack_time = 10 +  a*.500*ma.SR;
    decay_time = (d*1*ma.SR)+1;
    trg = trig <: _,_@attack_time : _+_ : _;
    env_time(counterpos)=ba.if(counterpos,attack_time,decay_time);
    count = ba.counter(trg) % 2;
    line = count : ba.line(env_time(count));
    ex = (ex_f-.5)*10 : round ;
    exf(in) = pow(in,ba.if(ex>1,ex,(-1/ex)));
    out = line : exf; 
}; 

//
trig = button("trig"):ba.impulsify;
a = hslider("a",0,0,1,0.01):si.smoo;
c = hslider("c decay-q",0,0,1,0.01):si.smoo;
//
imp(x) =  Drum_AD(trig,0,a, .95)*no.noise*.1;

base = hslider("b - basef",0,0,1,0.01)*900+10;
//
rez(f,n,spread,in) = out
with{
    gain = 1/3;
    q = 10+ 80*c;
    rezfilter(in, i) = out
    with{
        s = spread + 1;
        F = f*pow(s,i+1)%20000;
        filtering(i,in) = 
                in: fi.resonbp(F, q, gain)
                  : fi.resonlp(F, q, gain)
                  : fi.resonhp(F, q, gain)
                  : ba.if(f*pow(s,i) < 20000,_,0)
                  : ba.if(i<n,_,0)
                  * ((i%2)*impair + ((i+1)%2)*pair);
        
        impair = ba.if(k<.5,k*2,1); 
        pair   = ba.if(k>.5,-2*k+2,1);

        out = in : filtering(i);
    };
    out = sum(i,32,rezfilter(in,i)); 
};

f = hslider("freq", 1,1,800,1) : si.smoo; 
spread = hslider("spread",0,0,.9,0.001);
k = hslider("oddlvl",0,0,1,0.001);
n = hslider("noh",1,1,32,1);

process = trig : imp : rez(f,n,spread)*.1;
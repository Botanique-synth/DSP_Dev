import("stdfaust.lib");

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

Drum_DAD(trig,a1,d1,d2,ex_f2) = out
with{
    attack_time = 10 +  d1*.500*ma.SR;
    decay_time = d2*1.5*ma.SR;

    trg = trig <: _,_@attack_time : _+_ : _;

    env_time(counterpos)=ba.if(counterpos,attack_time,decay_time);

    count = ba.counter(trg) % 2;
    line = count : ba.line(env_time(count));
    
    ex = (ex_f2-.5)*10 : round ;
    exf(in) = pow(in,ba.if(ex>1,ex,(-1/ex)));

    out = line@a1 : exf; 
}; 


a1 = hslider("attack1", 0,0,1,0.01);
d1 = hslider("decay1", 0,0,1,0.01);
ex_f1 = hslider("exponent1",0,0,1,0.01);

a2 = hslider("attack2", 0,0,1,0.01);
d2 = hslider("decay2", 0,0,1,0.01);
del2 = hslider("delay", 0,0,1,0.01);
ex_f2 = hslider("exponent2",0,0,1,0.01);

trig = button("!"):ba.impulsify:abs;

process = kique_env(trig,d1,d2,ex_f1,ex_f2) <: _,_;


kique_env(trig,d1,d2,ex1,ex2) = out
with{
    out = Drum_AD(trig,0,d1,ex_f1),Drum_DAD(trig,0,d1,d2,ex_f2);
};
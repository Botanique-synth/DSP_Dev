import("stdfaust.lib");

additive(f,n,spread,k,trig) = tot
with{
    N = max(1, int(n));   // nombre d’harmoniques actif
    env = en.are(0.02,1,trig);
    s = spread + 1; 

    repeat(i) = oscfunc(i) * (1/(i+1)) * (i < N);
    oscfunc(i) = os.oscp(f*pow(s,i+1),0) //Harmonics @ f*2^(i+1)
               * (f*pow(s,i) < 20000)    //Antialiasing filter
               * ((i%2)*impair + ((i+1)%2)*pair);
    impair = ba.if(k<.5,k*2,1); 
    pair   = ba.if(k>.5,-2*k+2,1);  


    tot = sum(i,128,repeat(i)); // volume compemsation
};

f = hslider("freq", 1,1,800,1) : si.smoo; 
spread = hslider("spread",0,0,.9,0.001);
k = hslider("oddlvl",0,0,1,0.001);
trig = button("trig");
n = hslider("noh",1,1,64,1);

process = additive(f,n,spread,k,trig) * 0.2 ;

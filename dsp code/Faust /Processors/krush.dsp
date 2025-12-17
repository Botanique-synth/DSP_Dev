// input filter      x
// output filter     x
// bitcrish         x -> find bit number
// drive             x tanh and gain in input stage 
// downsample       x voir un peu plus comment ca marche -> faire le mien ?
// wavefold 
// freq shift /ring mod 

// stereo 

import("stdfaust.lib");

infilter(l,r) = hgroup("[0]Filters in", l,r : lp : hp)
with{
    lp = fi.resonlp(flp,qlp,g),fi.resonlp(flp,qlp,g);
    hp = fi.resonhp(fhp,qhp,g),fi.resonhp(fhp,qhp,g);

    flp = vslider("Lp cutoff",20000,20,20000,1);
    qlp = vslider("Lp Q",1,1,10,0.01);
    fhp = vslider("hp cutoff",2,2,20000,1);
    qhp = vslider("hp Q",1,1,10,0.01);

    g = vslider("Gain",1,1,10,0.01);
};

outfilt(l,r) = hgroup("[3]Filters out", l,r : lp : hp)
with{
    lp = fi.resonlp(flp,qlp,g),fi.resonlp(flp,qlp,g);
    hp = fi.resonhp(fhp,qhp,g),fi.resonhp(fhp,qhp,g);

    flp = vslider("Lp cutoff",20000,20,20000,1);
    qlp = vslider("Lp Q",1,1,10,0.01);
    fhp = vslider("hp cutoff",2,2,20000,1);
    qhp = vslider("hp Q",1,1,10,0.01);

    g = 1;
};

process = hgroup("lofi",test);
test = infilter : dspl : bcr : drive : outfilt;


dspl(l,r) = l,r : vgroup("[1]downsample",out)
with {
    n = vslider("amt",1,1,100,1);
    out = ba.downSample(ma.SR/n),ba.downSample(ma.SR/n);
    //stepping ??
};

bcr(l,r) = vgroup("[2]bcr", l,r : out)
with{
 nbits = vslider("bitcrush",1,0.05,1,0.001)*24 : round;
 out = ba.bitcrusher(nbits),ba.bitcrusher(nbits); 
};

drive(l,r) = l,r : out
with{
    sat = vslider("sat",1,0,1,0.001);
    out = aa.tanh1,aa.tanh1;
};
import("stdfaust.lib");

multiband(in) = out
with{
    f1 = hslider("f1",100,1,500,1);
    f2 = hslider("f2",1000,500,20000,1);
    split(in,f1,f2) = in : fi.crossover3LR4(f1,f2);

    p1(a) = a;
    p2(b) = b;
    p3(c) = c;

    merge(x,y,z) = x + y + z;

    out = split(in,f1,f2) : p1,p2,p3 : merge;
};

process = multiband; 
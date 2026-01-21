Siplus(ia,ib) = oa,ob
with{
    a = hslider("a",0,0,1,0.01);
    b = hslider("b",0,0,1,0.01);
    ca = nentry("freq [CV:1]", 440, 20, 20000, 1);
    cb = nentry("two [CV:2]", 0.3, 0, 10, 0.01);
    f(k,i) = k*i;
    oa = f(ia,a)*ca;
    ob = f(ib,b)*cb;
};
process=Siplus;

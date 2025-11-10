Hiplus(ia,ib,ic,id,ie,if) = oa,ob,oc,od,oe,of
with{
    a = hslider("a",0,0,1,0.01);
    b = hslider("b",0,0,1,0.01);
    c = hslider("c",0,0,1,0.01);
    d = hslider("d",0,0,1,0.01);
    e = hslider("e",0,0,1,0.01);
    f = hslider("f",0,0,1,0.01);

    ba = button("ba");
    bb = button("bb");
    bc = button("bc");
    bd = button("bd");
    be = button("be");
    bf = button("bf");

    ca = nentry("ca [CV:1]", 0, 0, 1, 0.01);
    cb = nentry("cb [CV:2]", 0, 0, 1, 0.01);
    cc = nentry("cc [CV:3]", 0, 0, 1, 0.01);
    cd = nentry("cd [CV:4]", 0, 0, 1, 0.01);
    ce = nentry("ce [CV:5]", 0, 0, 1, 0.01);
    cf = nentry("cf [CV:6]", 0, 0, 1, 0.01);

    p1(k,i)=k*i;

    oa = p1(ia,a)*ca*ba;
    ob = p1(ib,b)*cb*bb;
    oc = p1(ic,c)*cc*bc;
    od = p1(id,d)*cd*bd;
    oe = p1(ie,e)*ce*be;
    of = p1(if,f)*cf*bf;
};
process=Hiplus;

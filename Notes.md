# Faust research notes

here I'll dump all of my research in faust.
wip but chapters for now:

  1 - making interface
  2 - working with effects

1 - making working interface to test code

    for faust (two slider stereo)

'
stereo_interface(ia,ib) = oa,ob
with{
    a = hslider("a[CV1]",0,0,1,0.01);
    b = hslider("b[CV1]",0,0,1,0.01);
    f(k,i) = k*i;
    oa = f(ia,a);
    ob = f(ib,b);
};
process=stereo_interface;
'
[ok]

    for vcv
'
quad_interface(ia,ib,ic,id) = oa,ob,oc,od
with{
    sa = hslider("a[CV1]",0,0,1,0.01);
    sb = hslider("b[CV2]",0,0,1,0.01);
    sc = hslider("c[CV3]",0,0,1,0.01);
    sd = hslider("d[CV4]",0,0,1,0.01);

    ba = button("ba");
    bb = button("bb");
    bc = button("bc");
    bd = button("bd");

    f(k,i) = k*i;

    oa = (1-ba)*f(ia,sa);
    ob = (1-bb)*f(ib,sb);
    oc = (1-bc)*f(ic,sc);
    od = (1-bd)*f(id,sd);
};
[ok]

f_intf(ia,ib,ic,id,ie,if) = oa,ob,oc,od,oe,of
with{
    sa = hslider("sa[CV1]",0,0,1,0.01);
    sb = hslider("sb[CV2]",0,0,1,0.01);
    sc = hslider("sc[CV3]",0,0,1,0.01);
    sd = hslider("sd[CV4]",0,0,1,0.01);
    se = hslider("se[CV3]",0,0,1,0.01);
    sf = hslider("sf[CV4]",0,0,1,0.01);

    ba = button("ba");
    bb = button("bb");
    bc = button("bc");
    bd = button("bd");
    be = button("be");
    bf = button("bf");

    f(k,i) = k*i;

    oa = (1-ba)*f(ia,sa);
    ob = (1-bb)*f(ib,sb);
    oc = (1-bc)*f(ic,sc);
    od = (1-bd)*f(id,sd);
    oe = (1-be)*f(ie,se);
    of = (1-bf)*f(if,sf);
};
[ok]

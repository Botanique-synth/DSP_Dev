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

Si(ia,ib) = oa,ob
with{
    a = hslider("a[CV1]",0,0,1,0.01);
    b = hslider("b[CV1]",0,0,1,0.01);
    f(k,i) = k*i;
    oa = f(ia,a);
    ob = f(ib,b);
	};
process=Si;


# Faust research notes
*here I'll dump all of my research in Faust.
wip but chapters for now:*

		  I   - Making interface
		  II  - Working with sound
				  -   Drums
				  -   Synths
				  -   Fx
				  -   Fc


## 1 - Making Interfaces
*Id like to test my faust code in vcv and rnbo, the following code helps me crete inteface with different softwares*
*it'll allow be to have a starting code for future projects*
at the end of every code block u'll find links to download or check the code

### Interface for Faust (two slider stereo)
#### Simple two slider volume :
	Si(ia,ib) = oa,ob
	with{
	    a = hslider("a[CV1]",0,0,1,0.01);
	    b = hslider("b[CV1]",0,0,1,0.01);
	    f(k,i) = k*i;
	    oa = f(ia,a);
	    ob = f(ib,b);
	};
	process=Si;
Faust [x] vcv [x] (stereo io with 2 params)

#### Simple two knob two cv volume :
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
[x]Faust [x]vcv

### Interface for VCV/RNBO
#### Quad volume with cv :
	Qi(ia,ib,ic,id) = oa,ob,oc,od
	with{
	    a = hslider("a",0,0,1,0.01);
	    b = hslider("b",0,0,1,0.01);
	    c = hslider("c",0,0,1,0.01);
	    d = hslider("d",0,0,1,0.01);
	    ca = nentry("ca [CV:1]", 0, 0, 1, 0.01);
	    cb = nentry("cb [CV:2]", 0, 0, 1, 0.01);
	    cc = nentry("cc [CV:3]", 0, 0, 1, 0.01);
	    cd = nentry("cd [CV:4]", 0, 0, 1, 0.01);
	    f(k,i)=k*i;
	    oa = f(ia,a)*ca;
	    ob = f(ib,b)*cb;
	    oc = f(ic,c)*cc;
	    od = f(id,d)*cd;
	};
	process=Qi;
Faust [x] Vcv [x]

#### Hexa_interface (vcv max)

	Hi(ia,ib,ic,id,ie,if) = oa,ob,oc,od,oe,of
	with{
	    a = hslider("a",0,0,1,0.01);
	    b = hslider("b",0,0,1,0.01);
	    c = hslider("c",0,0,1,0.01);
	    d = hslider("d",0,0,1,0.01);
	    e = hslider("e",0,0,1,0.01);
	    f = hslider("f",0,0,1,0.01);

	    ca = nentry("ca [CV:1]", 0, 0, 1, 0.01);
	    cb = nentry("cb [CV:2]", 0, 0, 1, 0.01);
	    cc = nentry("cc [CV:3]", 0, 0, 1, 0.01);
	    cd = nentry("cd [CV:4]", 0, 0, 1, 0.01);
	    ce = nentry("ce [CV:5]", 0, 0, 1, 0.01);
	    cf = nentry("cf [CV:6]", 0, 0, 1, 0.01);

	    p1(k,i)=k*i;

	    oa = p1(ia,a)*ca;
	    ob = p1(ib,b)*cb;
	    oc = p1(ic,c)*cc;
	    od = p1(id,d)*cd;
	    oe = p1(ie,c)*ce;
	    of = p1(if,f)*cf;
	};
	process=Hi;
Faust [x] Vcv [x]

#### Hexa interface with buttons
	Hipus(ia,ib,ic,id,ie,if) = oa,ob,oc,od,oe,of
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
	    oe = p1(ie,c)*ce*be;
	    of = p1(if,f)*cf*bf;
	};
	process=Hiplus;
Faust [x] Vcv [x]
####  Simple Hexa interface (for rnbo export)
	Hirnbo(ia,ib,ic,id,ie,if) = oa,ob,oc,od,oe,of
	with{
	p1(k,i)=k*i;

	oa = p1(ia,1);
	ob = p1(ib,1);
	oc = p1(ic,1);
	od = p1(id,1);
	oe = p1(ie,1);
	of = p1(if,1);
	};
	process=Hirnbo;

Faust [x] Vcv [x] Rnbo[x]
## 2 - Dsp

Non exhaustive list of dsp effects ideas :
- Drums
	 - [ ] Kick
	 - [ ] Hats
	 - [ ] Snare
	 - [ ] Fm
	 - [ ] Phisicalm
- Synths
    - [x] Looper
	- [x] Ganular
	- [x] Karplus strong
	- [ ] Fm
	- [ ] Acid
	- [ ] Spectral (fft wip)
- Effects
	- [ ] Phaser
	- [ ] Flanger
	- [ ] Delay
	- [ ] Multiband
	- [ ] Saturation
- Filters
    - [x] Onezero
    - [x] Comb
- Function Generators
	- [ ] Turing machine
	- [ ] Env
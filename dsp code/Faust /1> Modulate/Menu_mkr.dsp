import("stdfaust.lib");
v = .2, .4, .8, 1;
s = nentry("select",0,0,3,1);
in = hslider("inval",0,-1,1,0.01);

preset4(inval,menu0t3) = outval
with{
    // 1 input value 
    lane1 = inval : ba.tAndH(menu0t3==0);  
       // add ,inval2 : ba.tAdnH(menu0t3==0) for inval2
    lane2 = inval : ba.tAndH(menu0t3==1);
    lane3 = inval : ba.tAndH(menu0t3==2);
    lane4 = inval : ba.tAndH(menu0t3==3);

    outval = lane1, lane2, lane3, lane4; 
    // 4 values for 4 pages 
};

process = preset4(in,s);
import("stdfaust.lib");

main_clock = timephasor : vbargraph("1 val",0,1)
with{
    x = vslider("bpm",120,20,200,1);
    run = 1-checkbox("Run!");
    timephasor = vgroup("[0] Main clock",os.hs_phasor(1.0,x/30/4,run));
};
pulse = (main_clock*-1:ba.spulse(1));

//del = +~(@1000*.5) ;
process = hgroup("loop",looper(main_clock));

looper(phasein,in) =  rwtable(tablesize,0.0,recIndex,in*record_d,readIndex)
with{
  record_d = button("[2]Record delete") : int;
  rec_a = button("[3]Record Add X"):int;
  tablesize = 48000;
  recIndex =  phasein *(float(tablesize)) * (record_d+rec_a): int;
  readIndex = phasein *(float(tablesize)) : int;
};
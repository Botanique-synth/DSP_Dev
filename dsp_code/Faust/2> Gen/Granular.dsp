import("stdfaust.lib");
looper(detune) = rwtable(tablesize,0.0,recIndex,_,readIndex)
with{
  record = button("[2]Record") : int;
  readSpeed = hslider("[0]Read Speed",1,0.001,10,0.01);
  tablesize = 48000;
  recIndex = (+(1) : %(tablesize)) ~ *(record);
  readIndex = readSpeed*(detune+1)/float(ma.SR) : (+ : ma.decimal) ~ _ : *(float(tablesize)) : int;
};
polyLooper = vgroup("Looper",_ <: par(i,nVoices,looper(detune*i)) :> _,_)
with{
  nVoices = 10;
  detune = hslider("Detune",0.01,0,1,0.01);
};
process = polyLooper : dm.zita_light;

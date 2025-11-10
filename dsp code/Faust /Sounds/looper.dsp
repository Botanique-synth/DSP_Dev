import("stdfaust.lib");
looper = rwtable(tablesize,0.0,recIndex,_,readIndex)
with{
  record = button("[2]Record") : int;
  readSpeed = hslider("[0]Read Speed",1,0.001,10,0.01);
  tablesize = 48000;
  recIndex = (+(1) : %(tablesize)) ~ *(record);
  readIndex = readSpeed/float(ma.SR) : (+ : ma.decimal) ~ _ : *(float(tablesize)) : int;
};
process = looper;

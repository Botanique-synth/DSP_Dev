import("stdfaust.lib");

echo = vgroup("echo", +~(@(Dl-1) : *(feedback)))
with{
    duration = hslider("[0]Duration",500,1,1000,1)*0.001;
    feedback = hslider("[1]Feedback",0,0,1,0.01);
    Dl = ma.SR*duration;
};
process = echo;

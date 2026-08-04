// https://ccrma.stanford.edu/~jos/fp/One_Zero.html
import("stdfaust.lib");
onezero = vgroup("OZf",_<: (_' :*(b1)),_ :> _)
with{
    b1 = hslider("b1",0,-1,1,0.01);
};
process = no,noise : onezero;

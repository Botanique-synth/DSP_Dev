
import("stdfaust.lib");

vol = hslider("vol",0,0,1,0.01) ;
process = no.noise*vol <: _,_ ;


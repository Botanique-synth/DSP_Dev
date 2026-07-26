import("stdfaust.lib");
n = library("numberfunctions.dsp");


nine        =  vgroup("[1]9",b.quadseq,_:_,_,_,_,_);
eight       =  vgroup("[3]8",b.instruments);
four        =  vgroup("[0]0",_);
five        =  vgroup("[0]0",_);
seven       =  vgroup("[0]0",_);
two         =  vgroup("[0]0",_);

one         =  vgroup("[4]1",_*.1);              // mixer 

three       =  vgroup("[5]3",_ <: b.krush(1));
six        =  vagroup("[0]0",_);

process = beatroot ;

beatroot = tgroup("channels",n.zero : n.nine <: (n.eight,n.synth_fx,n.synth_fx,n.synth_fx,n.synth_fx): n.one );
// zero:nine<:(eight,synth_fx,synth_fx,synth_fx):one for now in numberfunctions 

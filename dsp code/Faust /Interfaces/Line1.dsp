import("stdfaust.lib");

sequencer   = hgroup("seq",s1,s2)
with{
  s1 = vgroup("s1",seq1); 
  seq1 = vslider("[2]h1",0,0,1,0.01)
       * vslider("[0]k1[style:knob]",0,0,1,0.01)
       * vslider("[1]k2[style:knob]",0,0,1,0.01); 

  s2 = vgroup("s2",seq2);  
  seq2 = vslider("[2]h2",0,0,1,0.01)
        *vslider("[0]k3[style:knob]",0,0,1,0.01)
        *vslider("[1]k4[style:knob]",0,0,1,0.01); 
};
instrument(x,y)  = hgroup("instr",s1*x,s2*y)
with{
  s1 = vgroup("s1",seq1); 
  seq1 = vslider("[2]h1",0,0,1,0.01)
       * vslider("[0]k1[style:knob]",0,0,1,0.01)
       * vslider("[1]k2[style:knob]",0,0,1,0.01); 

  s2 = vgroup("s2",seq2);  
  seq2 = vslider("[2]h2",0,0,1,0.01)
        *vslider("[0]k3[style:knob]",0,0,1,0.01)
        *vslider("[1]k4[style:knob]",0,0,1,0.01); 
};
mixer(x,y)       = hgroup("mixx",s1*x,s2*y)
with{
  s1 = vgroup("s1",seq1); 
  seq1 = vslider("[2]h1",0,0,1,0.01)
       * vslider("[0]k1[style:knob]",0,0,1,0.01)
       * vslider("[1]k2[style:knob]",0,0,1,0.01); 

  s2 = vgroup("s2",seq2);  
  seq2 = vslider("[2]h2",0,0,1,0.01)
        *vslider("[0]k3[style:knob]",0,0,1,0.01)
        *vslider("[1]k4[style:knob]",0,0,1,0.01); 
};

line1 = hgroup("line1",sequencer : instrument : mixer);
process = line1;



//

import("stdfaust.lib");

sequencer_off   = hgroup("[0]seq",s1,s2)
with{
  s1 = vgroup("s1",seq1); 
  seq1 = vslider("[2]h1",0,0,1,0.01)
       * vslider("[0]k1[style:knob]",0,0,1,0.01)
       * vslider("[1]k2[style:knob]",0,0,1,0.01); 

  s2 = vgroup("s2",seq2);  
  seq2 = vslider("[2]h2",0,0,1,0.01)
        *vslider("[0]k3[style:knob]",0,0,1,0.01)
        *vslider("[1]k4[style:knob]",0,0,1,0.01); 
};
sequencer = vgroup("[0]trigs",t1,t2)
with{
    t1 = button("t1"):ba.impulsify;
    t2 = button("t2"):ba.impulsify;
};

instrument(x,y)  = hgroup("[1]instr",s1*x,s2*y)
with{
  s1 = vgroup("s1",seq1); 
  seq1 = vslider("[2]h1",0,0,1,0.01)
       * vslider("[0]k1[style:knob]",0,0,1,0.01)
       * vslider("[1]k2[style:knob]",0,0,1,0.01)
    ; 

  s2 = vgroup("s2",seq2);  
  seq2 = vslider("[2]h2",0,0,1,0.01)
        *vslider("[0]k3[style:knob]",0,0,1,0.01)
        *vslider("[1]k4[style:knob]",0,0,1,0.01); 
};
mixer(x,y)       = hgroup("[2]mixx",s1*x,s2*y)
with{
  s1 = vgroup("s1",seq1); 
  seq1 = vslider("[2]h1",0,0,1,0.01)
       * vslider("[0]k1[style:knob]",0,0,1,0.01)
       * vslider("[1]k2[style:knob]",0,0,1,0.01); 

  s2 = vgroup("s2",seq2);  
  seq2 = vslider("[2]h2",0,0,1,0.01)
        *vslider("[0]k3[style:knob]",0,0,1,0.01)
        *vslider("[1]k4[style:knob]",0,0,1,0.01); 
};

line1 = hgroup("line1",sequencer : instrument : mixer);
process = line1;
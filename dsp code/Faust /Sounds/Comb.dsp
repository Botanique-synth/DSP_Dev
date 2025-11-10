// https://ccrma.stanford.edu/~jos/pasp/Feedback_Comb_Filters.html

import("stdfaust.lib");
fcomb = vgroup("comb", +~(@(delLength-1) : *(feedback))
with{
    delLength = hslider("[0]Delay Length",1,1,100,1);
    feedback = hslider("[1]Feedback",0,0,1,0.01);
};
process = fcomb;

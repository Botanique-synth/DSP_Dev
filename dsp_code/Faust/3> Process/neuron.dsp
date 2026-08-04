import("stdfaust.lib");

bprog = button("back prog") : ba.impulsify;
lr    = hslider("lr", 0.01, 0, 1, 0.001);
targ  = hslider("target", 0, 0, 1, 0.01);   // training target for y

dtanh(y) = 1 - y*y;

// Route 4 inputs + target + trig into net_step, feeding back 45 weight signals
process(x1, x2, x3, x4) = (x1, x2, x3, x4, targ, bprog) 
    : (net_step ~ par(i, 45, _)) 
    : (_, par(i, 45, !));

net_step(x1, x2, x3, x4, target, trig,
    // Layer 1 weights (16) & biases (4)
    w1_11_in, w1_12_in, w1_13_in, w1_14_in,
    w1_21_in, w1_22_in, w1_23_in, w1_24_in,
    w1_31_in, w1_32_in, w1_33_in, w1_34_in,
    w1_41_in, w1_42_in, w1_43_in, w1_44_in,
    b1_1_in,  b1_2_in,  b1_3_in,  b1_4_in,
    // Layer 2 weights (16) & biases (4)
    w2_11_in, w2_12_in, w2_13_in, w2_14_in,
    w2_21_in, w2_22_in, w2_23_in, w2_24_in,
    w2_31_in, w2_32_in, w2_33_in, w2_34_in,
    w2_41_in, w2_42_in, w2_43_in, w2_44_in,
    b2_1_in,  b2_2_in,  b2_3_in,  b2_4_in,
    // Layer 3 weights (4) & bias (1)
    w3_1_in,  w3_2_in,  w3_3_in,  w3_4_in,  b3_in
) = y, 
    w1_11_out, w1_12_out, w1_13_out, w1_14_out,
    w1_21_out, w1_22_out, w1_23_out, w1_24_out,
    w1_31_out, w1_32_out, w1_33_out, w1_34_out,
    w1_41_out, w1_42_out, w1_43_out, w1_44_out,
    b1_1_out,  b1_2_out,  b1_3_out,  b1_4_out,
    w2_11_out, w2_12_out, w2_13_out, w2_14_out,
    w2_21_out, w2_22_out, w2_23_out, w2_24_out,
    w2_31_out, w2_32_out, w2_33_out, w2_34_out,
    w2_41_out, w2_42_out, w2_43_out, w2_44_out,
    b2_1_out,  b2_2_out,  b2_3_out,  b2_4_out,
    w3_1_out,  w3_2_out,  w3_3_out,  w3_4_out,  b3_out
with {
    xin(1)=x1; xin(2)=x2; xin(3)=x3; xin(4)=x4;

    // --- Active Weights (Default initial values at sample 0, fed-back state afterwards) ---
    w1(1,1) = select2(ba.time > 0, 1.0, w1_11_in);
    w1(1,2) = select2(ba.time > 0, 1.0, w1_12_in);
    w1(1,3) = select2(ba.time > 0, 1.0, w1_13_in);
    w1(1,4) = select2(ba.time > 0, 1.0, w1_14_in);
    w1(2,1) = select2(ba.time > 0, 1.0, w1_21_in);
    w1(2,2) = select2(ba.time > 0, 1.0, w1_22_in);
    w1(2,3) = select2(ba.time > 0, 1.0, w1_23_in);
    w1(2,4) = select2(ba.time > 0, 1.0, w1_24_in);
    w1(3,1) = select2(ba.time > 0, 1.0, w1_31_in);
    w1(3,2) = select2(ba.time > 0, 1.0, w1_32_in);
    w1(3,3) = select2(ba.time > 0, 1.0, w1_33_in);
    w1(3,4) = select2(ba.time > 0, 1.0, w1_34_in);
    w1(4,1) = select2(ba.time > 0, 1.0, w1_41_in);
    w1(4,2) = select2(ba.time > 0, 1.0, w1_42_in);
    w1(4,3) = select2(ba.time > 0, 1.0, w1_43_in);
    w1(4,4) = select2(ba.time > 0, 1.0, w1_44_in);

    b1(1) = select2(ba.time > 0, 0.0, b1_1_in);
    b1(2) = select2(ba.time > 0, 0.0, b1_2_in);
    b1(3) = select2(ba.time > 0, 0.0, b1_3_in);
    b1(4) = select2(ba.time > 0, 0.0, b1_4_in);

    w2(1,1) = select2(ba.time > 0, 1.0, w2_11_in);
    w2(1,2) = select2(ba.time > 0, 1.0, w2_12_in);
    w2(1,3) = select2(ba.time > 0, 1.0, w2_13_in);
    w2(1,4) = select2(ba.time > 0, 1.0, w2_14_in);
    w2(2,1) = select2(ba.time > 0, 1.0, w2_21_in);
    w2(2,2) = select2(ba.time > 0, 1.0, w2_22_in);
    w2(2,3) = select2(ba.time > 0, 1.0, w2_23_in);
    w2(2,4) = select2(ba.time > 0, 1.0, w2_24_in);
    w2(3,1) = select2(ba.time > 0, 1.0, w2_31_in);
    w2(3,2) = select2(ba.time > 0, 1.0, w2_32_in);
    w2(3,3) = select2(ba.time > 0, 1.0, w2_33_in);
    w2(3,4) = select2(ba.time > 0, 1.0, w2_34_in);
    w2(4,1) = select2(ba.time > 0, 1.0, w2_41_in);
    w2(4,2) = select2(ba.time > 0, 1.0, w2_42_in);
    w2(4,3) = select2(ba.time > 0, 1.0, w2_43_in);
    w2(4,4) = select2(ba.time > 0, 1.0, w2_44_in);

    b2(1) = select2(ba.time > 0, 0.0, b2_1_in);
    b2(2) = select2(ba.time > 0, 0.0, b2_2_in);
    b2(3) = select2(ba.time > 0, 0.0, b2_3_in);
    b2(4) = select2(ba.time > 0, 0.0, b2_4_in);

    w3(1) = select2(ba.time > 0, 1.0, w3_1_in);
    w3(2) = select2(ba.time > 0, 1.0, w3_2_in);
    w3(3) = select2(ba.time > 0, 1.0, w3_3_in);
    w3(4) = select2(ba.time > 0, 1.0, w3_4_in);
    b3    = select2(ba.time > 0, 0.5, b3_in);

    // ===== FORWARD PASS =====
    h1(i) = ma.tanh(x1*w1(i,1) + x2*w1(i,2) + x3*w1(i,3) + x4*w1(i,4) + b1(i));
    h2(i) = ma.tanh(h1(1)*w2(i,1) + h1(2)*w2(i,2) + h1(3)*w2(i,3) + h1(4)*w2(i,4) + b2(i));
    y     = ma.tanh(h2(1)*w3(1) + h2(2)*w3(2) + h2(3)*w3(3) + h2(4)*w3(4) + b3);

    // ===== BACKWARD PASS =====
    delta3 = (y - target) * dtanh(y);
    g3(i)  = delta3 * h2(i);
    gb3    = delta3;

    delta2(i) = (w3(i) * delta3) * dtanh(h2(i));
    g2(i,j)   = delta2(i) * h1(j);
    gb2(i)    = delta2(i);

    delta1(j) = (w2(1,j)*delta2(1) + w2(2,j)*delta2(2) + w2(3,j)*delta2(3) + w2(4,j)*delta2(4)) * dtanh(h1(j));
    g1(i,j)   = delta1(i) * xin(j);
    gb1(i)    = delta1(i);

    // ===== WEIGHT UPDATES =====
    w1_11_out = select2(trig, w1(1,1), w1(1,1) - lr * g1(1,1));
    w1_12_out = select2(trig, w1(1,2), w1(1,2) - lr * g1(1,2));
    w1_13_out = select2(trig, w1(1,3), w1(1,3) - lr * g1(1,3));
    w1_14_out = select2(trig, w1(1,4), w1(1,4) - lr * g1(1,4));
    w1_21_out = select2(trig, w1(2,1), w1(2,1) - lr * g1(2,1));
    w1_22_out = select2(trig, w1(2,2), w1(2,2) - lr * g1(2,2));
    w1_23_out = select2(trig, w1(2,3), w1(2,3) - lr * g1(2,3));
    w1_24_out = select2(trig, w1(2,4), w1(2,4) - lr * g1(2,4));
    w1_31_out = select2(trig, w1(3,1), w1(3,1) - lr * g1(3,1));
    w1_32_out = select2(trig, w1(3,2), w1(3,2) - lr * g1(3,2));
    w1_33_out = select2(trig, w1(3,3), w1(3,3) - lr * g1(3,3));
    w1_34_out = select2(trig, w1(3,4), w1(3,4) - lr * g1(3,4));
    w1_41_out = select2(trig, w1(4,1), w1(4,1) - lr * g1(4,1));
    w1_42_out = select2(trig, w1(4,2), w1(4,2) - lr * g1(4,2));
    w1_43_out = select2(trig, w1(4,3), w1(4,3) - lr * g1(4,3));
    w1_44_out = select2(trig, w1(4,4), w1(4,4) - lr * g1(4,4));

    b1_1_out  = select2(trig, b1(1), b1(1) - lr * gb1(1));
    b1_2_out  = select2(trig, b1(2), b1(2) - lr * gb1(2));
    b1_3_out  = select2(trig, b1(3), b1(3) - lr * gb1(3));
    b1_4_out  = select2(trig, b1(4), b1(4) - lr * gb1(4));

    w2_11_out = select2(trig, w2(1,1), w2(1,1) - lr * g2(1,1));
    w2_12_out = select2(trig, w2(1,2), w2(1,2) - lr * g2(1,2));
    w2_13_out = select2(trig, w2(1,3), w2(1,3) - lr * g2(1,3));
    w2_14_out = select2(trig, w2(1,4), w2(1,4) - lr * g2(1,4));
    w2_21_out = select2(trig, w2(2,1), w2(2,1) - lr * g2(2,1));
    w2_22_out = select2(trig, w2(2,2), w2(2,2) - lr * g2(2,2));
    w2_23_out = select2(trig, w2(2,3), w2(2,3) - lr * g2(2,3));
    w2_24_out = select2(trig, w2(2,4), w2(2,4) - lr * g2(2,4));
    w2_31_out = select2(trig, w2(3,1), w2(3,1) - lr * g2(3,1));
    w2_32_out = select2(trig, w2(3,2), w2(3,2) - lr * g2(3,2));
    w2_33_out = select2(trig, w2(3,3), w2(3,3) - lr * g2(3,3));
    w2_34_out = select2(trig, w2(3,4), w2(3,4) - lr * g2(3,4));
    w2_41_out = select2(trig, w2(4,1), w2(4,1) - lr * g2(4,1));
    w2_42_out = select2(trig, w2(4,2), w2(4,2) - lr * g2(4,2));
    w2_43_out = select2(trig, w2(4,3), w2(4,3) - lr * g2(4,3));
    w2_44_out = select2(trig, w2(4,4), w2(4,4) - lr * g2(4,4));

    b2_1_out  = select2(trig, b2(1), b2(1) - lr * gb2(1));
    b2_2_out  = select2(trig, b2(2), b2(2) - lr * gb2(2));
    b2_3_out  = select2(trig, b2(3), b2(3) - lr * gb2(3));
    b2_4_out  = select2(trig, b2(4), b2(4) - lr * gb2(4));

    w3_1_out  = select2(trig, w3(1), w3(1) - lr * g3(1));
    w3_2_out  = select2(trig, w3(2), w3(2) - lr * g3(2));
    w3_3_out  = select2(trig, w3(3), w3(3) - lr * g3(3));
    w3_4_out  = select2(trig, w3(4), w3(4) - lr * g3(4));
    b3_out    = select2(trig, b3,    b3    - lr * gb3);
};
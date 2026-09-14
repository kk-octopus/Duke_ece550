Netid: kt336
Name: Kaiwen Tang
# Checkpoint 1 - ALU
description: This project is a 32bits non-RCA(CLA). Along with a function to judge equal(subtraction), less than(subtraction), overflow. 
## Algorithm choosing
This project uses a hierarchical CLA algorthim to design a 32bit adder. Usually, I should have chosen CSA as the algorithm for this project. However, since the project asked us to do a non-RCA adder. I want to seek for faster algorithm. That's why I choose this carry-lookahead-adder.
## Files
- alu.v ---top-entity module
- cla_32bit.v ---32bit adder module
- cla_16bit.v ---16bit adder module
- cla_4bit.v ----4bit adder module
## Design method
### basics
For a FA:
- sum:   $Sum_i = (a \oplus b) \oplus C_i = p_i \oplus C_i$
- cout: define $C_{i+1} = g_i + p_iC_i$, where $g_i$ is propogate carry and $p_i$ is generate carry.
The reason why it defines like that because imagine when previous a,b are all 1, it will definitly produce a carry. So we can derive $p_i = a and b$. And if either a or b is 1, and $C_i$ is 1. It will produce a generate carry.
Thus we can conclude: 
$g_i = a_ib_i$
$p_i = (a_i \oplus b_i)$
and that's the basic for this algorithm.
#### example
C0 = cin;
C1 = g1 + p1C0;
C2 = g2 + p2C1 = g2(g1 + p1C0) = g2g1 +p1g2C0;
....
### core idea
For this algorithm, we only need to know what cin is and what the two [31:0]input is. Then we can figure out the carry for each row without waiting for the previous stage.

### architecture
We have already known the algorithm. But the problem is, calculating the cin(when index is very big like C31) requires a very long expression. So we can view 4bit cla_adder as a whole part and calculate its whole pi, gi to make it easier.
for a 4bit cla_adder, if we 
32bit cla_adder
|
16bit cla_adder ---- 16bit cla_adder
|
4bit cla_adder - 4bit cla_adder........
## Delay analysis & Comparison
The calculation below is based on the assumption that a FA has 2 delays, and gate has 1 delay. Multiple input and/or gate viewed as 1 delay.
For both of them, we only need to calculate the critical path which is C32(cout).
- CLA_alu --11 delay
layer 1: calculating all pi, gi; 1 delay
    p0,p1,p2......p31; +1 delay
    g0,g1,g2......g31; +1 delay
layer 2: calculating group(4bit) Gi,Pi; 2 delay
    P3,P7,P11...P31; +1 delay
    G3,G7,G11...G31; +2 delay
layer 3: calculating group(16bit) Gi,Pi; 2 delay
    P_low,P_high; + 1 delay
    G_low,G_high; + 2 delay
    P_low > 3 delay; G_low > 5 delay;
    P_high > 3 delay; G_high > 5 delay;
layer 4: top module
    C_low = G_low + P_lowCin; > 6 delay 
    C_high = G_hight + P_highC_low > 8 delay
    S31 = pi ^ C28 +1 delay;
    C28 = pi + giC_heigh +2 delay
total: S31 11 delay; C32 8 delay
conclusion: CLA is 11 delay
- CSA(8 * 4 RCAs) --29 delay
expression for mux is : Y = ~SD0 + SD1;
critical path is S > not > and > or, so 3 delay for a 2-1 mux.
Therefore, total delay is 4 * 2 + 7 * 3 = 29 delays
# Conclusion
Very tough work writing this project and wrting this README.md. Anyway I just want to use some better method outside of what we've learned.

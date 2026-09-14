module cla_4bit(a,b,cin,out,cout,Gi,Pi,overflow);
    input [3:0] a;
    input [3:0] b;
    input cin;
    output [3:0] out;
    output cout;
    output Gi, Pi;
    output overflow;

    wire [3:0] g;
    wire [3:0] p;
//middle parameter
    wire c1;
    wire [1:0] c2;
    wire [2:0] c3;
    wire [3:0] c4;
    wire C0, C1, C2, C3;

//ci = gi + pici;
    assign C0 = cin;

//calcultate carry in advance
    and(g[0], a[0], b[0]);
    and(g[1], a[1], b[1]);
    and(g[2], a[2], b[2]);
    and(g[3], a[3], b[3]);

    xor(p[0], a[0], b[0]);
    xor(p[1], a[1], b[1]);
    xor(p[2], a[2], b[2]);
    xor(p[3], a[3], b[3]);

//c1 = g0 + p0c0;
    and(c1, p[0], C0);
    or(C1, c1, g[0]);

//c2 = g1 + p1c1 = g1+p1g0+p1p0c0;
    and(c2[0], p[1], g[0]);
    and(c2[1], p[1], p[0], C0);
    or(C2, c2[0], c2[1], g[1]);

//c3 = g2 + p2c2 = g2 + p2g1 + p1p2g0 + p0p1p2c0;
    and(c3[0], p[2], g[1]);
    and(c3[1], p[1], p[2], g[0]);
    and(c3[2], p[0], p[1], p[2], C0);
    or(C3, c3[0], c3[1], c3[2], g[2]);

//c4 = g3 + p3g2 + p2p3g1 + p1p2p3g0 + p0p1p2p3c0 = cout;
    and(c4[0], p[3], g[2]);
    and(c4[1], p[2], p[3], g[1]);
    and(c4[2], p[3], p[1], p[2], g[0]);
    and(c4[3], p[0], p[1], p[2], p[3], C0);
    or(cout, c4[0], c4[1], c4[2], c4[3], g[3]);

//group Gi,Pi
    or(Gi, c4[0], c4[1], c4[2], g[3]);
    and(Pi, p[0], p[1], p[2], p[3]);

//si = pi ^ ci
    xor(out[0], p[0], C0);
    xor(out[1], p[1], C1);
    xor(out[2], p[2], C2);
    xor(out[3], p[3], C3);

//overflow
    xor(overflow, C3, cout);

endmodule

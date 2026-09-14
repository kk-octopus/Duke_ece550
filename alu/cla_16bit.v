module cla_16bit(a, b, cin, Gi, Pi, out, cout, overflow);
    input [15:0] a;
    input [15:0] b;
    input cin;
    output Gi,Pi;
    output [15:0] out;
    output cout;
    output overflow;

    wire [3:0] G;
    wire [3:0] P;
    wire c1;
    wire [1:0] c2;
    wire [2:0] c3;
    wire [3:0] c4;
    wire [3:0] C;
    wire [3:0] block;
    wire [3:0] flow;
//ci = gi + pici;
    assign C[0] = cin;

genvar i;
    generate
        for(i = 0; i < 4; i = i + 1) begin : block_cla4
        cla_4bit four1(
            .a(a[4 * i + 3 : 4 * i]),
            .b(b[4 * i + 3 : 4 * i]),
            .cin(C[i]),

            .out(out[4 * i + 3 : 4 * i]), 
            .cout(block[i]), 
            .Gi(G[i]), 
            .Pi(P[i]),
            .overflow(flow[i])
            );

        end

    endgenerate

//C1 = G0 + P0c0;
    and(c1, P[0], cin);
    or(C[1], c1, G[0]);

//C2 = G1 + P1C1 = G1+P1G0+P1G0P0;
    and(c2[0], P[1], G[0]);
    and(c2[1], P[1], P[0], C[0]);
    or(C[2], c2[0], c2[1], G[1]);

//C3 = G2 + P2C2 = G2 + P2G1 + P1P2G0 + P0P1P2C0;
    and(c3[0], P[2], G[1]);
    and(c3[1], P[1], P[2], G[0]);
    and(c3[2], P[0], P[1], P[2], C[0]);
    or(C[3], c3[0], c3[1], c3[2], G[2]);

//C4 = G3 + P3G2 + P2P3G1 + P1P2P3G0 + P0P1P2P3C0 = cout;
    and(c4[0], P[3], G[2]);
    and(c4[1], P[2], P[3], G[1]);
    and(c4[2], P[3], P[1], P[2], G[0]);
    and(c4[3], P[0], P[1], P[2], P[3], C[0]);
    or(cout, c4[0], c4[1], c4[2], c4[3], G[3]);
//end of second-layer CLA

//group Gi,Pi
    or(Gi, c4[0], c4[1], c4[2], G[3]);
    and(Pi, P[0], P[1], P[2], P[3]);

//overflow
    assign overflow = flow[3];
endmodule